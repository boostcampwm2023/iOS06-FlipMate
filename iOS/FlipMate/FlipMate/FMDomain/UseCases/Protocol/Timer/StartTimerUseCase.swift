//
//  TimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import Combine
import Core

protocol StartTimerUseCase {
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
