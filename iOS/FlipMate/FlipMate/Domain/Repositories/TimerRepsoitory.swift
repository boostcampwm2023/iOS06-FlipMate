//
//  TimerRepsoitory.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation
import Combine

protocol TimerRepsoitory {
    func startTimer(
        startTime: Date,
        userId: Int,
        categoryId: Int
    ) -> AnyPublisher<Void, NetworkError>
    
    func finishTimer(
        endTime: Date,
        learningTime: Int,
        userId: Int,
        categoryId: Int
    ) -> AnyPublisher<Void, NetworkError>
}
