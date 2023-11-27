//
//  CategorySettingViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit
import Combine

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
        Task {
            await readCategories()
        }
    }
    
    deinit {
        viewModel.didFinishCategorySetting()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
    }
}

// MARK: - ViewModel Functions
private extension CategorySettingViewController {
    func readCategories() async {
        do {
            try await viewModel.readCategories()
        } catch let error {
            FMLogger.general.error("카테고리 읽는 중 에러 발생 : \(error)")
        }
    }
    
    func deleteCategory(id: Int) async {
        do {
            try await viewModel.deleteCategory(of: id)
        } catch let error {
            FMLogger.general.error("카테고리 삭제 중 에러 발생 : \(error)")
        }
    }
}

// MARK: - CollectionViewDelegate
extension CategorySettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showActionSheet()
    }
}

// MARK: - objc function
private extension CategorySettingViewController {
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "카테고리 수정", style: .default) { [weak self] _ in
            guard let self = self,
                  let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
            guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            self.viewModel.updateCategoryTapped(category: item.category)
        }
        
        let deleteAction = UIAlertAction(title: "카테고리 삭제", style: .destructive) { [weak self] _ in
            guard let self = self,
                  let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
            guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            showDeleteAlert()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(modifyAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @objc func showDeleteAlert() {
        guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let alert = UIAlertController(title: "카테고리 삭제", 
                                      message: "\(item.category.subject)을(를) 정말 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.deleteCategory(id: item.category.id)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
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
