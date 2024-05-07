//
//  CGFloat++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/07.
//

import Foundation

extension CGFloat {
    /// CGFloat 값을 라디안 값으로 변환하여 리턴합니다.
    func toRadian() -> CGFloat {
        return self * 2 * CGFloat.pi
    }
}
