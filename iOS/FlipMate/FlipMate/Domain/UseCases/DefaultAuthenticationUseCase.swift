//
//  DefaultGoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class DefaultAuthenticationUseCase: AuthenticationUseCase {
    private let repository: AuthenticationRepository
    private let signoutManager: SignOutManagerProtocol
    
    public init(repository: AuthenticationRepository, signoutManager: SignOutManagerProtocol) {
        self.repository = repository
        self.signoutManager = signoutManager
    }
    
    func googleLogin(accessToken: String) async throws -> User {
        return try await repository.googleLogin(with: accessToken)
    }
    
    func appleLogin(accessToken: String) async throws -> User {
        return try await repository.appleLogin(with: accessToken)
    }
    
    func signOut() {
        signoutManager.signOut()
    }
}
