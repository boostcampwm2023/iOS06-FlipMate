//
//  DefaultAppleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Core

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    private let repository: AuthenticationRepository
    private let keychainManager = KeychainManager()
    
    public init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    func appleLogin(accessToken: String, userID: String) async throws -> User {
        let response = try await repository.appleLogin(with: accessToken)
        let userAccessToken = response.accessToken
        try keychainManager.saveAccessToken(token: userAccessToken)
        try keychainManager.saveAppleUserID(id: userID)
        return response
    }
}
