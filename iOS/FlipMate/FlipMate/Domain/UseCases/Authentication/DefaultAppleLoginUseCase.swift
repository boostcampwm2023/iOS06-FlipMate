//
//  DefaultAppleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    private let repository: AuthenticationRepository
    private let keychainManager: KeychainManagable
    
    public init(repository: AuthenticationRepository, keychainManager: KeychainManagable) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func appleLogin(accessToken: String, userID: String) async throws -> User {
        let response = try await repository.appleLogin(with: accessToken)
        let userAccessToken = response.accessToken
        try keychainManager.saveAccessToken(token: userAccessToken)
        try keychainManager.saveAppleUserID(id: userID)
        return response
    }
}
