//
//  DefaultGoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class DefaultGoogleLoginUseCase: GoogleLoginUseCase {
    private let repository: AuthenticationRepository
    
    public init(repository: AuthenticationRepository, signoutManager: SignOutManagerProtocol) {
        self.repository = repository
    }
    
    func googleLogin(accessToken: String) async throws -> User {
        return try await repository.googleLogin(with: accessToken)
    }
}

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    private let repository: AuthenticationRepository
    
    public init(repository: AuthenticationRepository, signoutManager: SignOutManagerProtocol) {
        self.repository = repository
    }
    
    func appleLogin(accessToken: String) async throws -> User {
        return try await repository.appleLogin(with: accessToken)
    }
}

final class DefaultSignOutUseCase: SignOutUseCase {
    private let signoutManager: SignOutManagerProtocol
    
    public init(repository: AuthenticationRepository, signoutManager: SignOutManagerProtocol) {
        self.signoutManager = signoutManager
    }
    
    func signOut() {
        signoutManager.signOut()
    }
}
