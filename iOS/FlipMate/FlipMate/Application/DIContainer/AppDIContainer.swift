//
//  AppDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

final class AppDIContainer {
    lazy var signOutManager: SignOutManagerProtocol = SignOutManager(userInfoManager: userInfoManager)
    lazy var provider: Provider = Provider(urlSession: URLSession.shared, signOutManager: signOutManager)
    lazy var categoryManager: CategoryManageable = CategoryManager(categories: [])
    lazy var userInfoManager: UserInfoManagerProtocol = UserInfoManager()
    
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
            userInfoManager: userInfoManager
        )
        
        return LoginDIContainer(dependencies: dependencies)
    }
}
