//
//  DefaultWithdrawUesCase.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/09.
//

import Foundation
import Core

final class DefaultWithdrawUesCase: WithdrawUseCase {
    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    func withdraw() async throws {
        try await repository.withdraw()
        signOut()
    }
    
    private func signOut() {
        NotificationCenter.default.post(name: NotificationName.signOut, object: nil)
    }
}
