//
//  TimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import Combine

/// 타이머 Usecase을 추상화한 프로토콜
protocol TimerUseCase {
    /// 타이머 작동
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
