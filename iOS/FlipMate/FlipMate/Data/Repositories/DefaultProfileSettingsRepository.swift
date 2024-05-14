//
//  DefaultSignUpRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation
import Core

final class DefaultProfileSettingsRepository: ProfileSettingsRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func checkIfNickNameIsDuplicated(_ nickName: String) async throws -> Bool {
        let endpoint = SignUpEndpoints.nickNameValidation(nickName)
        let response = try await provider.request(with: endpoint)
        return !response.isUnique
    }
    
    func setupNewProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo {
        let endpoint = SignUpEndpoints.userSignUp(nickName: nickName, profileImageData: profileImageData)
        let response = try await provider.request(with: endpoint)
        FMLogger.general.log("유저 정보 설정 완료 : \(response.nickName)")
        return UserInfo(name: response.nickName, profileImageURL: response.imageURL, email: response.email)
    }
}
