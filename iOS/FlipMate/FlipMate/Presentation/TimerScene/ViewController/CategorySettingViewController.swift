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
        viewModel.presentingCategoryModifyViewControllerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.createCategoryButtonTapped()
            }
            .store(in: &cancellables)
        
        viewModel.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                guard var snapShot = self.dataSource?.snapshot() else { return }
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
}

// MARK: - CollectionViewDelegate
extension CategorySettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
    
    func createCategoryButtonTapped() {
        let presentingViewController = CategoryModifyViewController(
            title: "카테고리 추가", viewModel: self.viewModel)
        let navController = UINavigationController(rootViewController: presentingViewController)
        present(navController, animated: true)
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

@available(iOS 17.0, *)
#Preview {
    CategorySettingViewController(
        viewModel: CategoryViewModel(
            useCase: DefaultCategoryUseCase(
                repository: DefaultCategoryRepository(
                    provider: Provider(urlSession: URLSession.shared)))))
}
