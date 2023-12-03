//
//  String++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/29/23.
//

import Foundation

extension String {
    func stringToDate(_ dateFormat: Date.FMDateFormmat) -> Date? {
        return DateFormatter.FMDateFormat(dateFormat: dateFormat).date(from: self)
    }
}
