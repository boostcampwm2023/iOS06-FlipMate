//
//  DefaultTimerFinishUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/27.
//

import Foundation
import Combine

final class DefaultTimerFinishUseCase: TimerFinishUseCase {
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
