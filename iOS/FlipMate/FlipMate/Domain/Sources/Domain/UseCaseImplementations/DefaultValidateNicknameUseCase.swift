//
//  DefaultValidateNicknameUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

import Core

public final class DefaultValidateNicknameUseCase: ValidateNicknameUseCase {
    private let validator: NickNameValidatable
    
    public init(validator: NickNameValidatable) {
        self.validator = validator
    }
    
    public func isNickNameValid(_ nickName: String) -> NickNameValidationState {
        let validationState = validator.checkNickNameValidationState(nickName)
        return validationState
    }
}
