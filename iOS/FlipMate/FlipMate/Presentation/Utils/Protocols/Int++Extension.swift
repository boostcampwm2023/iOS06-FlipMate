//
//  Int++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/16.
//

import Foundation

extension Int {
    /// 정수를 통해 HH:mm:ss 형식의 문자열로 만들어 리턴합니다.
    func secondsToStringTime() -> String {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = self % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
