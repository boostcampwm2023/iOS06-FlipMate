//
//  DefaultSignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

final class DefaultProfileSettingsUseCase: ProfileSettingsUseCase {
    
    private let repository: ProfileSettingsRepository
    private let validator: NickNameValidatable
    
    init(repository: ProfileSettingsRepository, validator: NickNameValidatable) {
        self.repository = repository
        self.validator = validator
    }
    
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState {
        let validationState = validator.checkNickNameValidationState(nickName)
        return validationState
    }
    
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo {
        return try await repository.setupNewProfileInfo(nickName: nickName, profileImageData: profileImageData)
    }
}
