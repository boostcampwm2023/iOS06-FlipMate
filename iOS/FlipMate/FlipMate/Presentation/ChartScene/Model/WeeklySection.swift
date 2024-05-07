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
    case dateCell(String)
    
    var date: String {
        switch self {
        case .dateCell(let date):
            return date
        }
    }
}
