//
//  DefaultPatchTimeZoneUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

public final class DefaultPatchTimeZoneUseCase: PatchTimeZoneUseCase {
    private let repository: UserInfoRepository
    
    public init(repository: UserInfoRepository) {
        self.repository = repository
    }
    
    public func patchTimeZone(date: Date) async throws {
        try await repository.patchTimeZone(date: date)
    }
}
