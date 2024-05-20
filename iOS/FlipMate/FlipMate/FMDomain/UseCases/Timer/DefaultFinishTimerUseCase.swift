//
//  DefaultFinishTimerUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Core
import Foundation
import Combine

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
