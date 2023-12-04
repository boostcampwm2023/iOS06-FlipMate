//
//  SignOutManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import Foundation
import Combine

protocol SignOutManagerProtocol {
    var signOutPublisher: AnyPublisher<Bool, Never> { get }
    
    func signOut()
}

final class SignOutManager: SignOutManagerProtocol {
    private var signOutSubject = PassthroughSubject<Bool, Never>()
    
    var signOutPublisher: AnyPublisher<Bool, Never> {
        return signOutSubject.eraseToAnyPublisher()
    }
    
    func signOut() {
        try? KeychainManager.deleteAccessToken()
        signOutSubject.send(true)
    }
}
