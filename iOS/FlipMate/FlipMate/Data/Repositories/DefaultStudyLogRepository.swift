//
//  DefaultStudyLogRespository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Core
import Foundation
import Combine
import Network

final class DefaultStudyLogRepository: StudyLogRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func getUserInfo() -> AnyPublisher<StudyLog, NetworkError> {
        let endpoint = StudyLogEndpoints.getStudyLog()
        
        return provider.request(with: endpoint)
            .map { response -> StudyLog in
                return response.toEntity()
            }
            .eraseToAnyPublisher()
    }
    
    func studingPing() async throws {
        let endpoint = StudyLogEndpoints.studingPing()
        
        _ = try await provider.request(with: endpoint)
    }
}
