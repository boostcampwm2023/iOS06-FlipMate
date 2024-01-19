//
//  AppDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

final class AppDIContainer {
    lazy var keychainManager: KeychainManagable = KeychainManager()
    lazy var signOutManager: SignOutManagable = SignOutManager(userInfoManager: userInfoManager, keychainManager: keychainManager)
    lazy var provider: Provider = Provider(urlSession: URLSession.shared, signOutManager: signOutManager, keychainManager: keychainManager)
    lazy var categoryManager: CategoryManagable = CategoryManager(categories: [])
    lazy var userInfoManager: UserInfoManagable = UserInfoManager()
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager,
            signOutManager: signOutManager,
            userInfoManager: userInfoManager
        )
        
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    func makeLoginDiContainer() -> LoginDIContainer {
        let dependencies = LoginDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager,
            signOutManager: signOutManager,
            userInfoManager: userInfoManager,
            keychainManager: keychainManager
        )
        
        return LoginDIContainer(dependencies: dependencies)
    }
}
