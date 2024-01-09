//
//  DefaultWithdrawUesCase.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/09.
//

import Foundation

final class DefaultWithdrawUesCase: WithdrawUseCase {
    private let repository: AuthenticationRepository
    private let signOutManager: SignOutManagerProtocol
    
    init(repository: AuthenticationRepository, signOutManager: SignOutManagerProtocol) {
        self.repository = repository
        self.signOutManager = signOutManager
    }
    
    func withdraw() async throws {
        try await repository.withdraw()
        signOutManager.signOut()
    }
}
