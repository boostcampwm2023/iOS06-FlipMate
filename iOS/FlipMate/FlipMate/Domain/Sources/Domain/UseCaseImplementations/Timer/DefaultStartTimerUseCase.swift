//
//  DefaultStartTimerUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public final class DefaultStartTimerUseCase: StartTimerUseCase {
    private let timerRepository: TimerRepsoitory
    
    public init(timerRepository: TimerRepsoitory) {
        self.timerRepository = timerRepository
    }
    
    public func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        return timerRepository.startTimer(startTime: startTime, categoryId: categoryId)
    }
}
