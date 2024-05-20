//
//  DefaultSetupProfileInfoUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultSetupProfileInfoUseCase: SetupProfileInfoUseCase {
    private let repository: ProfileSettingsRepository
    
    init(repository: ProfileSettingsRepository) {
        self.repository = repository
    }
    
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo {
        return try await repository.setupNewProfileInfo(nickName: nickName, profileImageData: profileImageData)
    }
}
