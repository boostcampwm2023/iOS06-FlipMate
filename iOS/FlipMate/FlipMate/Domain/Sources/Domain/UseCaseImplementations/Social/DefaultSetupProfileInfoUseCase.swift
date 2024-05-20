//
//  DefaultSetupProfileInfoUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

public final class DefaultSetupProfileInfoUseCase: SetupProfileInfoUseCase {
    private let repository: ProfileSettingsRepository
    
    public init(repository: ProfileSettingsRepository) {
        self.repository = repository
    }
    
    public func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo {
        return try await repository.setupNewProfileInfo(nickName: nickName, profileImageData: profileImageData)
    }
}
