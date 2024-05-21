//
//  DefaultFinishTimerUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

// TODO: UseCase의 구현체들이 class일 필요가 있을까?
public final class DefaultFinishTimerUseCase: FinishTimerUseCase {
    private let timerRepository: TimerRepsoitory
    
    public init(timerRepository: TimerRepsoitory) {
        self.timerRepository = timerRepository
    }
    
    public func finishTimer(endTime: Date, learningTime: Int, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        return timerRepository.finishTimer(
            endTime: endTime,
            learningTime: learningTime,
            categoryId: categoryId)
    }
}
