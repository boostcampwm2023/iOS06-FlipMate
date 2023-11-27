//
//  DefaultGoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class DefaultGoogleAuthUseCase: GoogleAuthUseCase {
    private let repository: GoogleAuthRepository
    
    public init(repository: GoogleAuthRepository) {
        self.repository = repository
    }
    
    func googleLogin(accessToken: String) async throws -> User {
        return try await repository.login(with: accessToken)
    }
}
