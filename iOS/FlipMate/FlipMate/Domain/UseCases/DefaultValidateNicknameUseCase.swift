//
//  DefaultSignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

final class DefaultValidateNicknameUseCase: ValidateNicknameUseCase {
    private let validator: NickNameValidatable
    
    init(validator: NickNameValidatable) {
        self.validator = validator
    }
    
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState {
        let validationState = validator.checkNickNameValidationState(nickName)
        return validationState
    }
}
