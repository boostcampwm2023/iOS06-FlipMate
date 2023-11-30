//
//  SignUpUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/27/23.
//

import Foundation

protocol SignUpUseCase {
    func isNickNameValid(_ nickName: String) async throws -> NickNameValidationState
    func isSafeProfileImage(_ imageData: Data) async throws -> Bool
    func signUpUser(nickName: String, profileImageData: Data) async throws
}
