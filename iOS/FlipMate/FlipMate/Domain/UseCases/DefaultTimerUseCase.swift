//
//  DefaultTimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import Combine

final class DefaultStartTimerUseCase: StartTimerUseCase {
    private let timerRepository: TimerRepsoitory

    init(timerRepository: TimerRepsoitory) {
        self.timerRepository = timerRepository
    }
    
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        return timerRepository.startTimer(startTime: startTime, categoryId: categoryId)
    }
}

final class DefaultFinishTimerUseCase: FinishTimerUseCase {
    private let timerRepository: TimerRepsoitory
    
    init(timerRepository: TimerRepsoitory) {
        self.timerRepository = timerRepository
    }
    
    func finishTimer(endTime: Date, learningTime: Int, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        return timerRepository.finishTimer(
            endTime: endTime,
            learningTime: learningTime,
            categoryId: categoryId)
    }
}
