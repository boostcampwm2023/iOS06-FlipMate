//
//  DefaultTimerRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation
import Combine

final class DefaultTimerRepository {
    private enum StudyType: String {
        case start
        case finish
    }
    
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
}

extension DefaultTimerRepository: TimerRepsoitory {
    func startTimer(
        startTime: Date,
        categoryId: Int?)
    -> AnyPublisher<Void, NetworkError> {
        let requestDTO = TimerStartRequestDTO(
            date: startTime.dateToString(format: .yyyyMMdd),
            createdAt: startTime.dateToString(format: .yyyyMMddhhmmssZZZZZ),
            type: StudyType.start.rawValue,
            learningTime: 0,
            categoryID: categoryId)
        let endpoint = TimerEndpoints.startTimer(with: requestDTO)
        
        return provider.request(with: endpoint)
            .map { _ in
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func finishTimer(
        endTime: Date,
        learningTime: Int,
        categoryId: Int?)
    -> AnyPublisher<Void, NetworkError> {
        let requestDTO = TimerFinishRequestDTO(
            date: endTime.dateToString(format: .yyyyMMdd),
            createdAt: endTime.dateToString(format: .yyyyMMddhhmmssZZZZZ),
            type: StudyType.finish.rawValue,
            learningTime: learningTime,
            categoryID: categoryId)
        let endpoint = TimerEndpoints.stopTimer(with: requestDTO)
    
        return provider.request(with: endpoint)
            .map { _ in
                return ()
            }
            .eraseToAnyPublisher()
    }
}
