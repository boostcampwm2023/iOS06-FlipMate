//
//  CategorySettingViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit
import Combine
import DesignSystem

final class CategorySettingViewController: BaseViewController {
    typealias CategoryDataSource
    = UICollectionViewDiffableDataSource<CategorySettingSection, CategorySettingItem>
    typealias Snapshot
    = NSDiffableDataSourceSnapshot<CategorySettingSection, CategorySettingItem>
    
    // MARK: - Properties
    private var dataSource: CategoryDataSource?
    private let viewModel: CategoryViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryListCollectionViewCell.self)
        collectionView.register(CategorySettingFooterView.self, kind: .footer)
        return collectionView
    }()
    
    // MARK: - Initializers
    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("can't use this view controller in storyboard")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        setDelegate()
        setSnapshot()
    }
    
    deinit {
        viewModel.didFinishCategorySetting()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        title = Constant.title
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func bind() {
        viewModel.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                guard var snapShot = self.dataSource?.snapshot() else { return }
                snapShot.deleteAllItems()
                snapShot.appendSections([.categorySection([])])
                snapShot.appendItems(categories.map { CategorySettingItem.categoryCell($0) })
                self.dataSource?.apply(snapShot)
            }
            .store(in: &cancellables)
        
        viewModel.selectedCategoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                guard let self = self else { return }
                showActionSheet(with: category)
            }
            .store(in: &cancellables)
        
        viewModel.categoryPullPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showAlert()
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionViewDelegate
extension CategorySettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.cellDidTapped(category: item.category)
    }
}

// MARK: - objc function
private extension CategorySettingViewController {
    func showActionSheet(with category: Category) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions = createActionSheet(with: category)
        
        for action in actions {
                actionSheet.addAction(action)
            }
        
        self.present(actionSheet, animated: true)
    }
    
    func showDeleteAlert(with category: Category) {
        let alert = UIAlertController(title: category.subject,
                                      message: Constant.deleteAlertMessage,
                                      preferredStyle: .alert)
        
        let actions = createDeleteAlert(with: category)
        
        for action in actions {
                alert.addAction(action)
            }
        
        self.present(alert, animated: true)
    }
}

// MARK: - DiffableDataSource
private extension CategorySettingViewController {
    func setDataSource() {
        dataSource = CategoryDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .categoryCell(let category):
                    let cell: CategoryListCollectionViewCell = collectionView
                        .dequeueReusableCell(for: indexPath)
                    cell.updateUI(category: category)
                    cell.setTimeLabelHidden(isHidden: true)
                    return cell
                }
            })
        
        dataSource?
            .supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
                let footer: CategorySettingFooterView = collectionView
                    .dequeueReusableView(for: indexPath, kind: kind)
                footer.cancellable = footer.tapPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        self?.viewModel.createCategoryTapped()
                    }
                return footer
            }
    }
    
    func setDelegate() {
        collectionView.delegate = self
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [CategorySettingSection] = [.categorySection([])]
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
    }
    
    func updateCategoryTapped(with category: Category) {
        viewModel.updateCategoryTapped(category: category)
    }
}

// MARK: - CompositionalLayout
private extension CategorySettingViewController {
    func makeLayoutSection(sectionType: CategorySettingSection) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: sectionType.itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: sectionType.groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionType.footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        section.contentInsets = sectionType.sectionInset
        section.interGroupSpacing = sectionType.itemSpacing
        return section
    }
    
    func setCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionType = self?.dataSource?.snapshot()
                .sectionIdentifiers[sectionIndex] else { return nil }
            return self?.makeLayoutSection(sectionType: sectionType)
        }
    }
}

// MARK: - Alert function

private extension CategorySettingViewController {
    func createActionSheet(with category: Category) -> [UIAlertAction] {
        let modifyAction = UIAlertAction(title: Constant.modifyCategory, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateCategoryTapped(category: category)
        }
        
        let deleteAction = UIAlertAction(title: Constant.deleteCategory, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            showDeleteAlert(with: category)
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        return [modifyAction, deleteAction, cancelAction]
    }
    
    func createDeleteAlert(with category: Category) -> [UIAlertAction] {
        let deleteAction = UIAlertAction(title: Constant.delete, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            Task {
                try await self.viewModel.deleteCategory(of: category.id)
            }
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        return [deleteAction, cancelAction]
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: Constant.addCategory,
            message: Constant.categoryAddMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

private extension CategorySettingViewController {
    enum Constant {
        static let title = NSLocalizedString("category", comment: "")
        static let cancel = NSLocalizedString("cancel", comment: "")
        static let delete = NSLocalizedString("delete", comment: "")
        static let deleteCategory = NSLocalizedString("deleteCategory", comment: "")
        static let modifyCategory = NSLocalizedString("modifyCategory", comment: "")
        static let deleteAlertMessage = NSLocalizedString("deleteAlertMessage", comment: "")
        static let okTitle = NSLocalizedString("ok", comment: "")
        static let addCategory = NSLocalizedString("addCategory", comment: "")
        static let categoryAddMessage = NSLocalizedString("categoryAddMessage", comment: "")
    }
}
