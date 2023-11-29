//
//  SignUpRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

protocol SignUpRepository {
    func checkIfNickNameIsDuplicated(_ nickName: String) async throws -> Bool
    func checkProfileImageSafety(_ imageData: Data) async throws -> Bool
    func signUpNewUser(nickName: String, profileImageData: Data) async throws
}
