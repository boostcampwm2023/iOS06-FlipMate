//
//  DefaultSignOutUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

import Core

public struct DefaultSignOutUseCase: SignOutUseCase {
    
    public init() {}
    
    public func signOut() {
        NotificationCenter.default.post(name: NotificationName.signOut, object: nil)
    }
}
