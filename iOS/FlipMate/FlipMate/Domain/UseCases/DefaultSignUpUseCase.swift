//
//  DefaultSignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

final class DefaultSignUpUseCase: SignUpUseCase {
    
    private let repository: SignUpRepository
    private let validator: NickNameValidatable
    
    init(repository: SignUpRepository, validator: NickNameValidatable) {
        self.repository = repository
        self.validator = validator
    }
    
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState {
        let isDuplicated = try await repository.checkIfNickNameIsDuplicated(nickName)
        guard isDuplicated else {
            return .duplicated
        }
        let validationState = validator.checkNickNameValidationState(nickName)
        return validationState
    }
    
    func isNickNameDuplicated(_ nickName: String) async throws -> Bool {
        return try await repository.checkIfNickNameIsDuplicated(nickName)
    }
    
    func isSafeProfileImage(_ imageData: Data) async throws -> Bool {
        return try await repository.checkProfileImageSafety(imageData)
    }
    
    func signUpUser(nickName: String, profileImageData: Data) async throws {
        return try await repository.signUpNewUser(nickName: nickName, profileImageData: profileImageData)
    }
}
