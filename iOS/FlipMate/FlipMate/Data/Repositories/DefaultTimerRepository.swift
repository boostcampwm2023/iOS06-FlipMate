//
//  DefaultTimerRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation
import Combine

final class DefaultTimerRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
}

extension DefaultTimerRepository: TimerRepsoitory {
    func startTimer(
        startTime: Date,
        userId: Int,
        categoryId: Int)
    -> AnyPublisher<Void, NetworkError> {
        let requestDTO = TimerStartRequestDTO(
            date: startTime.dateToString(format: .yyyyMMdd),
            createdAt: startTime.dateToString(format: .yyyyMMddhhmmss),
            type: "start",
            learningTime: 0,
            userID: userId,
            categoryID: categoryId)
        let endpoint = TimerEndpoints.startTimer(with: requestDTO)
        
        return provider.request(with: endpoint)
            .map { response -> Void in
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func finishTimer(
        endTime: Date,
        learningTime: Int,
        userId: Int,
        categoryId: Int) 
    -> AnyPublisher<Void, NetworkError> {
        let requestDTO = TimerFinishRequestDTO(
            date: endTime.dateToString(format: .yyyyMMdd),
            createdAt: endTime.dateToString(format: .yyyyMMddhhmmss),
            type: "finish",
            learningTime: learningTime,
            userID: userId,
            categoryID: categoryId)
        let endpoint = TimerEndpoints.stopTimer(with: requestDTO)
    
        return provider.request(with: endpoint)
            .map { response -> Void in
                return ()
            }
            .eraseToAnyPublisher()
    }
}
