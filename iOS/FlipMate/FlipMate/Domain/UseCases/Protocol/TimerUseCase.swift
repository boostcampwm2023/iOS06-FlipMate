//
//  TimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation

/// 타이머 Usecase을 추상화한 프로토콜
protocol TimerUseCase {
    func startTimer(startTime: Date)
    func resumeTimer()
    func suspendTimer()
    func stopTimer(stopTime: Date)
}
