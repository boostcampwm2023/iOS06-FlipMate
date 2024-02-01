//
//  DefaultSignOutUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultSignOutUseCase: SignOutUseCase {
    private let signoutManager: SignOutManageable
    
    public init(signoutManager: SignOutManageable) {
        self.signoutManager = signoutManager
    }
    
    func signOut() {
        signoutManager.signOut()
    }
}
