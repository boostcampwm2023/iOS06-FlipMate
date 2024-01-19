//
//  DefaultGoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultGoogleLoginUseCase: GoogleLoginUseCase {
    private let repository: AuthenticationRepository
    private let keychainManager: KeychainManagable
    
    public init(repository: AuthenticationRepository, keychainManager: KeychainManagable) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func googleLogin(accessToken: String) async throws -> User {
        let response = try await repository.googleLogin(with: accessToken)
        let userAccessToken = response.accessToken
        try keychainManager.saveAccessToken(token: userAccessToken)
        return response
    }
}
