//
//  DefaultTimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import Combine

/// 타이머 작동 비즈니스 로직을 가지고 있는 Usecase
class DefaultTimerUseCase: TimerUseCase {
    private let timerManager = TimerManager()
    private let timerRepository: TimerRepsoitory
    
    init(timerRepository: TimerRepsoitory) {
        self.timerRepository = timerRepository
    }
    
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        timerManager.start(startTime: startTime)
        return timerRepository.startTimer(startTime: startTime, categoryId: categoryId)
    }

    func resumeTimer(resumeTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        timerManager.resume(resumeTime: resumeTime)
        return timerRepository.startTimer(startTime: resumeTime, categoryId: categoryId)
    }

    func suspendTimer(suspendTime: Date) -> Int {
        let totalTime = timerManager.totalTime
        timerManager.suspend()
        return totalTime
    }

    func stopTimer() {
        timerManager.cancel()
    }
}
