//
//  TimerRepsoitory.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Core
import Foundation
import Combine

protocol TimerRepsoitory {
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
