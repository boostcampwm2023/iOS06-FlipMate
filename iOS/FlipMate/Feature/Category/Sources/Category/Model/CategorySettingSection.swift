//
//  CategorySettingSection.swift
//  
//
//  Created by 권승용 on 5/30/24.
//

import UIKit
import Domain

enum CategorySettingSection: Hashable {
    case categorySection([CategorySettingItem])
}

enum CategorySettingItem: Hashable {
    case categoryCell(StudyCategory)
    
    var category: StudyCategory {
        switch self {
        case .categoryCell(let category):
            return category
        }
    }
}

extension CategorySettingSection {
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
