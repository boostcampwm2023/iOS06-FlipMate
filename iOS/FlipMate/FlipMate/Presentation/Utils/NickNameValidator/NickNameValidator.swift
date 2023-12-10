//
//  NickNameValidator.swift
//  FlipMate
//
//  Created by 권승용 on 11/29/23.
//

import Foundation

protocol NickNameValidatable {
    func checkNickNameValidationState(_ nickName: String) -> NickNameValidationState
}

final class NickNameValidator: NickNameValidatable {
    func checkNickNameValidationState(_ nickName: String) -> NickNameValidationState {
        enum Constant {
            static let maxLenght = 10
            static let minLength = 2
        }
        
        if nickName.count > Constant.maxLenght {
            return NickNameValidationState.lengthViolation
        }
        
        if nickName.isEmpty || nickName.count < Constant.minLength {
            return NickNameValidationState.emptyViolation
        }
        
        // TODO: FlipMate 서비스에 맞는 다양한  닉네임 제약조건 검사
        return NickNameValidationState.valid
    }
}
