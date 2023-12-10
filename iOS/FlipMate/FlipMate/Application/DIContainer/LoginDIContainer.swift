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
        let categoryManager: CategoryManageable
        let signOutManager: SignOutManagerProtocol
        let userInfoManager: UserInfoManagerProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController {
        return LoginViewController(
            loginViewModel: LoginViewModel(
                googleAuthUseCase: DefaultAuthenticationUseCase(
                    repository: DefaultAuthenticationRepository(
                        provider: dependencies.provider),
                    signoutManager: dependencies.signOutManager),
                actions: actions
            )
        )
    }
    
    func makeSignUpViewController(actions: SignUpViewModelActions) -> UIViewController {
        return SignUpViewController(
            viewModel: SignUpViewModel(
                usecase: DefaultProfileSettingsUseCase(
                    repository: DefaultProfileSettingsRepository(
                        provider: dependencies.provider),
                    validator: NickNameValidator()),
                actions: actions
            )
        )
    }
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager,
            signOutManager: dependencies.signOutManager,
            userInfoManager: dependencies.userInfoManager
        )
        
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(
            navigationViewController: navigationController,
            dependencies: self
        )
    }
}
