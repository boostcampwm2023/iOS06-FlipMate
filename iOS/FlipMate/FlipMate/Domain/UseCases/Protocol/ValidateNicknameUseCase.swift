//
//  ValidateNicknameUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

protocol ValidateNicknameUseCase {
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState
}
