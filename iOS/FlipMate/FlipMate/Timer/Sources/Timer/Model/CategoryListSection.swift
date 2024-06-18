//
//  CategoryListSection.swift
//
//
//  Created by 임현규 on 6/14/24.
//

import UIKit
import Domain

enum CategoryListSection: Hashable {
    case categorySection([CategoryListItem])
}

enum CategoryListItem: Hashable {
    case categoryCell(StudyCategory)
    
    var category: StudyCategory {
        switch self {
        case .categoryCell(let category):
            return category
        }
    }
}

extension CategoryListSection {
    var itemSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(58))
    }
    
    var groupSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(58))
    }
    
    var footerSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(130))
    }
    
    var sectionInset: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    }
    
    var itemSpacing: CGFloat {
        return 10
    }
}
