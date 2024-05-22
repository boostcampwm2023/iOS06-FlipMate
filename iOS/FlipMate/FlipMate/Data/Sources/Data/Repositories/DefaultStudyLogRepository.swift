//
//  DefaultStudyLogRespository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation
import Combine

import Domain
import Network
import Core

public final class DefaultStudyLogRepository: StudyLogRepository {
    private let provider: Providable
    
    public init(provider: Providable) {
        self.provider = provider
    }
    
    public func getUserInfo() -> AnyPublisher<StudyLog, NetworkError> {
        let endpoint = StudyLogEndpoints.getStudyLog()
        
        return provider.request(with: endpoint)
            .map { response -> StudyLog in
                return response.toEntity()
            }
            .eraseToAnyPublisher()
    }
    
    public func studingPing() async throws {
        let endpoint = StudyLogEndpoints.studingPing()
        
        _ = try await provider.request(with: endpoint)
    }
}
