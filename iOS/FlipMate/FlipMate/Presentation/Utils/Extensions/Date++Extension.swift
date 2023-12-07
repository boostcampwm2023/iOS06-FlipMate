//
//  Date++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation

extension Date {
    enum FMDateFormmat: String {
        case yyyyMMdd = "yyyy-MM-dd"
        case yyyyMMddhhmmss = "yyyy-MM-dd HH:mm:ss"
    }
    
    /// 파라미터로 전달받은 format의 타입으로 Date을 문자열로 변환하여 리턴합니다.
    func dateToString(format: FMDateFormmat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    static func FMDateFormat(dateFormat: Date.FMDateFormmat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        /// locale & timezone
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        print(Locale.current.identifier, TimeZone.current.identifier)
        return formatter
    }
}
