//
//  File.swift
//  
//
//  Created by 권승용 on 6/2/24.
//

import Foundation

public enum WeeklySection: Hashable {
    case section([WeeklySectionItem])
}

public enum WeeklySectionItem: Hashable {
    case dateCell(String)
    
    var date: String {
        switch self {
        case .dateCell(let date):
            return date
        }
    }
}
