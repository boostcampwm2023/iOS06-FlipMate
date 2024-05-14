//
//  Int++Extension.swift
//
//
//  Created by 권승용 on 5/14/24.
//

import Foundation

extension Int {
    /// 정수를 통해 HH:mm:ss 형식의 문자열로 만들어 리턴합니다.
    public func secondsToStringTime() -> String {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = self % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
