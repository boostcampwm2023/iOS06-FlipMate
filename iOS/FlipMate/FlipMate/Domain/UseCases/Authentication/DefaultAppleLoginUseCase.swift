//
//  DefaultAppleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    private let repository: AuthenticationRepository
    
    public init(repository: AuthenticationRepository, signoutManager: SignOutManagerProtocol) {
        self.repository = repository
    }
    
    func appleLogin(accessToken: String) async throws -> User {
        return try await repository.appleLogin(with: accessToken)
    }
}
