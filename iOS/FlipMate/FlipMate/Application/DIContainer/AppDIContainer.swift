//
//  AppDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

final class AppDIContainer {
    lazy var signOutManager: SignOutManagerProtocol = SignOutManager()
    lazy var provider: Provider = Provider(urlSession: URLSession.shared, signOutManager: signOutManager)
    lazy var categoryManager: CategoryManageable = CategoryManager(categories: [])
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager)
        
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    func makeLoginDiContainer() -> LoginDIContainer {
        let dependencies = LoginDIContainer.Dependencies(provider: provider, categoryManager: categoryManager)
        
        return LoginDIContainer(dependencies: dependencies)
    }
}
