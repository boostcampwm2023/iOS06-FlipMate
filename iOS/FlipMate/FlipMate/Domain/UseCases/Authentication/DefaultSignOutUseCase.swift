//
//  DefaultSignOutUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultSignOutUseCase: SignOutUseCase {
    private let signoutManager: SignOutManagerProtocol
    
    public init(signoutManager: SignOutManagerProtocol) {
        self.signoutManager = signoutManager
    }
    
    func signOut() {
        signoutManager.signOut()
    }
}
