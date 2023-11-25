//
//  AppDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

final class AppDIContainer {
    lazy var provider: Provider = Provider(urlSession: URLSession.shared)
    lazy var categoryManager: CategoryManager = CategoryManager()
    
    func makeTimerSceneDIContainer() -> TimerSceneDIContainer {
        let dependencies = TimerSceneDIContainer.Dependencies(
            provider: provider,
            categoryManager: categoryManager)
        
        return TimerSceneDIContainer(dependencies: dependencies)
    }
    
    func makeLoginDiContainer() -> LoginDIContainer {
        let dependencies = LoginDIContainer.Dependencies(provider: provider)
        
        return LoginDIContainer(dependencies: dependencies)
    }
}
