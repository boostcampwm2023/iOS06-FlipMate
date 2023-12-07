//
//  DefaultStudingPingUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/07.
//

import Foundation

final class DefaultStudingPingUseCase: StudingPingUseCase {
    private let repository: StudyLogRepository
    
    init(repository: StudyLogRepository) {
        self.repository = repository
    }
    
    func studingPing() async throws {
        try await repository.studingPing()
    }
}
