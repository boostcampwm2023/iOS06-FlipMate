//
//  ValidateNicknameUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

import Core

public protocol ValidateNicknameUseCase {
    func isNickNameValid(_ nickName: String) -> NickNameValidationState
}
