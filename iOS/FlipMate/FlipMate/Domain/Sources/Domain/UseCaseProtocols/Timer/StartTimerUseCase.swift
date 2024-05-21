//
//  StartTimerUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol StartTimerUseCase {
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
