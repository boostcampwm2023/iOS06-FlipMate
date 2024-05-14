//
//  String++Extension.swift
//
//
//  Created by 권승용 on 5/14/24.
//

import Foundation

extension String {
    public func toDate(_ dateFormat: Date.FMDateFormmat) -> Date? {
        return DateFormatter.FMDateFormat(dateFormat: dateFormat).date(from: self)
    }
}
