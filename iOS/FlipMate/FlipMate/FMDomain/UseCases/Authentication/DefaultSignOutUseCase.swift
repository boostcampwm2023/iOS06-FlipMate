//
//  DefaultSignOutUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Core

final class DefaultSignOutUseCase: SignOutUseCase {
    
    func signOut() {
        NotificationCenter.default.post(name: NotificationName.signOut, object: nil)
    }
}
