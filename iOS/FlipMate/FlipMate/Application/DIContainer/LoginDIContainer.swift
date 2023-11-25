//
//  LoginDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

final class LoginDIContainer: LoginFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManager
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController {
        return LoginViewController(
            loginViewModel: LoginViewModel(
                googleAuthUseCase: DefaultGoogleAuthUseCase(
                    repository: DefaultGoogleAuthRepository(
                        provider: dependencies.provider)
                ),
                actions: actions
            )
        )
    }
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager)
        
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(
            navigationViewController: navigationController,
            dependencies: self
        )
    }
}
