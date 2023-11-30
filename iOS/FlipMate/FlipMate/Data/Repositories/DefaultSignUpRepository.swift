//
//  DefaultSignUpRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

final class DefaultSignUpRepository: SignUpRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func checkIfNickNameIsDuplicated(_ nickName: String) async throws -> Bool {
        let endpoint = SignUpEndpoints.nickNameValidation(nickName)
        let response = try await provider.request(with: endpoint)
        return !response.isUnique
    }
    
    // API 필요
    func checkProfileImageSafety(_ imageData: Data) async throws -> Bool {
        FMLogger.general.error("API 미구현, 항상 true 반환")
        return true
    }
    
    func signUpNewUser(nickName: String, profileImageData: Data) async throws {
        let endpoint = SignUpEndpoints.userSignUp(nickName: nickName, profileImageData: profileImageData)
        let response = try await provider.request(with: endpoint)
        FMLogger.general.log("유저 회원가입 완료 : \(response.nickName)")
    }
}
