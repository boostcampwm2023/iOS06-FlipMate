//
//  TabBarDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

final class TabBarDIContainer: TabBarFlowCoordinatorDependencies {
    
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManageable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTabBarController() -> UITabBarController {
        return TabBarViewController()
    }
    
    func makeTimerDIContainer() -> TimerSceneDIContainer {
        let dependencies = TimerSceneDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager
        )
        
        return TimerSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSocialDIContainer() -> SocialDIContainer {
        let dependencies = SocialDIContainer.Dependencies(
            provider: dependencies.provider)
        
        return SocialDIContainer(dependencies: dependencies)
    }
    
    func makeChartDIContainer() -> ChartDIContainer {
        let dependencies = ChartDIContainer.Dependencies(provider: dependencies.provider)
        
        return ChartDIContainer(dependencies: dependencies)
    }
    
    func makeTimerViewController() -> UIViewController {
        return UIViewController()
    }
    
    func makeTabBarFlowCoordinator(navigationController: UINavigationController?) -> TabBarFlowCoordinator {
        return TabBarFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
