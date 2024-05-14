//
//  File.swift
//  
//
//  Created by 권승용 on 5/14/24.
//

import Foundation

extension CGFloat {
    /// CGFloat 값을 라디안 값으로 변환하여 리턴합니다.
    public func toRadian() -> CGFloat {
        return self * 2 * CGFloat.pi
    }
}
