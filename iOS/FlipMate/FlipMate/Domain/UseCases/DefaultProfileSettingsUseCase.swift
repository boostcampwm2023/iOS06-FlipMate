//
//  DefaultSignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

final class DefaultValidateNicknameUseCase: ValidateNicknameUseCase {
    private let validator: NickNameValidatable
    
    init(repository: ProfileSettingsRepository, validator: NickNameValidatable) {
        self.validator = validator
    }
    
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState {
        let validationState = validator.checkNickNameValidationState(nickName)
        return validationState
    }
}

final class DefaultSetupProfileInfoUseCase: SetupProfileInfoUseCase {
    private let repository: ProfileSettingsRepository
    
    init(repository: ProfileSettingsRepository, validator: NickNameValidatable) {
        self.repository = repository
    }

    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo {
        return try await repository.setupNewProfileInfo(nickName: nickName, profileImageData: profileImageData)
    }
}
