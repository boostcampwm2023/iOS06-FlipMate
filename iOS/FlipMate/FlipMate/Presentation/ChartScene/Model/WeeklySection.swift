//
//  WeeklySection.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/07.
//

import UIKit

enum WeeklySection: Hashable {
    case section([WeeklySectionItem])
}

enum WeeklySectionItem: Hashable {
    case dateCell(Int)
}

extension WeeklySection {
    var itemSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.1425),
            heightDimension: .estimated(30)
        )
    }
    
    var groupSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30))
    }
}
