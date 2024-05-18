//
//  DateFormatter++Extension.swift
//  
//
//  Created by 권승용 on 5/14/24.
//

import Foundation

extension DateFormatter {
    public static func FMDateFormat(dateFormat: Date.FMDateFormmat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter
    }
}
