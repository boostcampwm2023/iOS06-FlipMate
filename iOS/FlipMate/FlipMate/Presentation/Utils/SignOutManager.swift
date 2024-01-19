//
//  SignOutManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import Foundation
import Combine

protocol SignOutManageable {
    var signOutPublisher: AnyPublisher<Bool, Never> { get }
    func signOut()
}

final class SignOutManager: SignOutManageable {
    private var signOutSubject = PassthroughSubject<Bool, Never>()
    private let userInfoManager: UserInfoManageable
    private let keychainManager: KeychainManageable
    
    init(userInfoManager: UserInfoManageable, keychainManager: KeychainManageable) {
        self.userInfoManager = userInfoManager
        self.keychainManager = keychainManager
    }
    
    var signOutPublisher: AnyPublisher<Bool, Never> {
        return signOutSubject.eraseToAnyPublisher()
    }
    
    func signOut() {
        try? keychainManager.deleteAccessToken()
        try? keychainManager.deleteAppleUserID()
        // MAKR: - UserInfoManager 초기화
        userInfoManager.initManager()
        signOutSubject.send(true)
    }
}
