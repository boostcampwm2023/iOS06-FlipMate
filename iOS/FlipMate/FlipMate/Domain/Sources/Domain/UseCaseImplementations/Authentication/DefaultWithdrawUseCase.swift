//
//  DefaultWithdrawUesCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

import Core

public final class DefaultWithdrawUesCase: WithdrawUseCase {
    private let repository: AuthenticationRepository
    
    public init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    public func withdraw() async throws {
        try await repository.withdraw()
        signOut()
    }
    
    private func signOut() {
        NotificationCenter.default.post(name: NotificationName.signOut, object: nil)
    }
}
