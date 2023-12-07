//
//  SignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/27/23.
//

import Foundation

protocol ProfileSettingsUseCase {
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo
}
