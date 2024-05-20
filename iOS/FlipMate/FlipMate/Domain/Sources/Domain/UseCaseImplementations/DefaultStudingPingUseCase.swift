//
//  DefaultStudingPingUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

public final class DefaultStudingPingUseCase: StudingPingUseCase {
    private let repository: StudyLogRepository
    
    public init(repository: StudyLogRepository) {
        self.repository = repository
    }
    
    public func studingPing() async throws {
        try await repository.studingPing()
    }
}
