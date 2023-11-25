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
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(
            loginViewModel: LoginViewModel(
                googleAuthUseCase: DefaultGoogleAuthUseCase(
                    repository: DefaultGoogleAuthRepository(
                        provider: dependencies.provider)
                )
            )
        )
    }
    
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(
            navigationViewController: navigationController,
            dependencies: self
        )
    }
}
