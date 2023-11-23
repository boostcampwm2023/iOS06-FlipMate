//
//  CategorySettingSection.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImltaHllb25neXUyQGdtYWlsLmNvbSIsIm5pY2tuYW1lIjoiaW1oeWVvbmd5dTJhVzFvZVdWdmJtZDVkVEpBWjIxaGFXd3VZMjl0ZFc1a1pXWnBibVZrIiwidHlwZSI6ImFjY2VzcyIsImF1dGhfdHlwZSI6Imdvb2dsZSIsImlhdCI6MTcwMDc0MzIzMywiZXhwIjoxNzAzMzM1MjMzfQ.t00zwpUfUoKgxBQ0iK6ThMompboXA0hyZCIjAPIpTHU"

enum CategorySettingSection: Hashable {
    case categorySection([CategorySettingItem])
}

enum CategorySettingItem: Hashable {
    case categoryCell(Category)
    
    var category: Category {
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
            heightDimension: .absolute(58))
    }
    
    var sectionInset: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    }
    
    var itemSpacing: CGFloat {
        return 10
    }
}
