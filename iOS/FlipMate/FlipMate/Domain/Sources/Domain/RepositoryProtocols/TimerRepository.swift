//
//  TimerRepsoitory.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation
import Combine

import Core

public protocol TimerRepsoitory {
    func startTimer(
        startTime: Date,
        categoryId: Int?
    ) -> AnyPublisher<Void, NetworkError>
    
    func finishTimer(
        endTime: Date,
        learningTime: Int,
        categoryId: Int?
    ) -> AnyPublisher<Void, NetworkError>
}
