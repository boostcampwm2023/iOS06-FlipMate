//
//  AppDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit
import Core
import Network

final class AppDIContainer {
    lazy var provider: Provider = Provider(urlSession: URLSession.shared, keychainManager: KeychainManager())
    lazy var categoryManager: CategoryManageable = CategoryManager(categories: [])
    lazy var userInfoManager: UserInfoManageable = UserInfoManager()
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager,
            userInfoManager: userInfoManager
        )
        
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    func makeLoginDiContainer() -> LoginDIContainer {
        let dependencies = LoginDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager,
            userInfoManager: userInfoManager
        )
        
        return LoginDIContainer(dependencies: dependencies)
    }
}
