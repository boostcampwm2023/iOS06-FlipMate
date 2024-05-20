//
//  FinishTimerUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol FinishTimerUseCase {
    func finishTimer(endTime: Date, learningTime: Int, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
