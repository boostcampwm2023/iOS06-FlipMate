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
    
    func startTimer(startTime: Date, userId: Int, categoryId: Int) -> AnyPublisher<Void, NetworkError> {
        timerManager.start(startTime: startTime)
        return timerRepository.startTimer(startTime: startTime, userId: userId, categoryId: categoryId)
    }

    func resumeTimer(resumeTime: Date, userId: Int, categoryId: Int) -> AnyPublisher<Void, NetworkError> {
        timerManager.resume(resumeTime: resumeTime)
        return timerRepository.startTimer(startTime: resumeTime, userId: userId, categoryId: categoryId)
    }

    func suspendTimer(suspendTime: Date, userId: Int, categoryId: Int) -> AnyPublisher<Int, NetworkError> {
        let totalTime = timerManager.totalTime
        timerManager.suspend()
        return timerRepository.finishTimer(endTime: suspendTime, learningTime: totalTime, userId: userId, categoryId: categoryId)
            .map { response -> Int in
                return totalTime
            }
            .eraseToAnyPublisher()
    }

    func stopTimer() {
        timerManager.cancle()
    }
}
