//
//  CategorySettingViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

final class CategorySettingViewController: BaseViewController {
    typealias CateogoryDataSource = UICollectionViewDiffableDataSource<CategorySettingSection,CategorySettingItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CategorySettingSection, CategorySettingItem>

    // MARK: - Properties
    private var dataSource: CateogoryDataSource?
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryListCollectionViewCell.self)
        collectionView.register(CategorySettingFooterView.self, kind: .footer)
        return collectionView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        setSnapshot()
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
}

// MARK: - DiffableDataSource
private extension CategorySettingViewController {
    func setDataSource() {
        dataSource = CateogoryDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .categoryCell(let category):
                let cell: CategoryListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateUI(category: category)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footer: CategorySettingFooterView = collectionView.dequeueReusableView(for: indexPath, kind: kind)
            return footer
        }
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [CategorySettingSection] = [.categorySection([])]
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
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
            guard let sectionType = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else { return nil }
            return self?.makeLayoutSection(sectionType: sectionType)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CategorySettingViewController()
}
