//
//  DefaultGoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
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
