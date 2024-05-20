//
//  DefaultGoogleLoginUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

import Core

public final class DefaultGoogleLoginUseCase: GoogleLoginUseCase {
    private let repository: AuthenticationRepository
    private let keychainManager = KeychainManager()
    
    public init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    public func googleLogin(accessToken: String) async throws -> User {
        let response = try await repository.googleLogin(with: accessToken)
        let userAccessToken = response.accessToken
        try keychainManager.saveAccessToken(token: userAccessToken)
        return response
    }
}
