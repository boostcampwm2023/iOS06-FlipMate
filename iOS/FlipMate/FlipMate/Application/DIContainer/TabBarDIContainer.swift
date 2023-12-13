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
        let signOutManager: SignOutManagerProtocol
        let userInfoManager: UserInfoManagerProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTabBarController() -> TabBarViewController {
        return TabBarViewController()
    }
    
    func makeTimerDIContainer() -> TimerSceneDIContainer {
        let dependencies = TimerSceneDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager,
            userInfoManager: dependencies.userInfoManager
        )
        
        return TimerSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSocialDIContainer() -> SocialDIContainer {
        let dependencies = SocialDIContainer.Dependencies(
            provider: dependencies.provider,
            signOutManager: dependencies.signOutManager,
            userInfoManager: dependencies.userInfoManager
        )
        
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
