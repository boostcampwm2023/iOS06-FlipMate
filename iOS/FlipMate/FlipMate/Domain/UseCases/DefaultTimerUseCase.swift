//
//  DefaultTimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import OSLog

/// 타이머 작동 비즈니스 로직을 가지고 있는 Usecase
class DefaultTimerUseCase: TimerUseCase {
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "test")

    private lazy var timerManager = TimerManager()
    
    func startTimer(startTime: Date) {
        timerManager.start(startTime: startTime)
    }

    func resumeTimer(resumeTime: Date) {
        timerManager.resume(resumeTime: resumeTime)
    }

    func suspendTimer() -> Int {
        timerManager.suspend()
        return timerManager.totalTime
    }

    func stopTimer(stopTime: Date) {
        timerManager.cancle()
    }
}
