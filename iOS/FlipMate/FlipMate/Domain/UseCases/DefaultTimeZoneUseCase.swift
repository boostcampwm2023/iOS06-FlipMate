//
//  DefaultTimeZoneUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/13.
//

import Foundation

final class DefaultTimeZoneUseCase: TimeZoneUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository) {
        self.repository = repository
    }
    
    func patchTimeZone(date: Date) async throws {
        try await repository.patchTimeZone(date: date)
    }
}
