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
        case yyyyMMddTHHmmSS = "yyyy-MM-dd'T'HH:mm:ss"
        case yyyyMMddhhmmssZZZZZ = "yyyy-MM-dd HH:mm:ssZZZZZ"
        case ZZZZZ = "ZZZZZ"
        case day = "dd"
    }
    
    /// 파라미터로 전달받은 format의 타입으로 Date을 문자열로 변환하여 리턴합니다.
    func dateToString(format: FMDateFormmat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    static func FMDateFormat(dateFormat: Date.FMDateFormmat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter
    }
}
