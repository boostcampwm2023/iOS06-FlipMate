//
//  String++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/29/23.
//

import Foundation

extension String {
    func stringToDate() -> Date? {
        return DateFormatter.FMDateFormat.date(from: self)
    }
}
