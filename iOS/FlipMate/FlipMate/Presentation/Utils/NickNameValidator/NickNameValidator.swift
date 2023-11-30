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
        if nickName.count > 20 {
            return NickNameValidationState.lengthViolation
        }
        if nickName.isEmpty {
            return NickNameValidationState.emptyViolation
        }
        // TODO: FlipMate 서비스에 맞는 다양한  닉네임 제약조건 검사
        return NickNameValidationState.valid
    }
}
