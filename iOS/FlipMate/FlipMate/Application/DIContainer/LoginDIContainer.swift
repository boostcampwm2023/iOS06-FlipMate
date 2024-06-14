//
//  LoginDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit
import Login
import Timer
import Domain
import Network
import Core
import Data
import CategoryService

final class LoginDIContainer: LoginFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManageable
        let userInfoManager: UserInfoManageable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController {
        let repository = DefaultAuthenticationRepository(provider: dependencies.provider)
        return LoginViewController(
            loginViewModel: LoginViewModel(
                googleLoginUseCase: DefaultGoogleLoginUseCase(
                    repository: repository),
                appleLoginUseCase: DefaultAppleLoginUseCase(
                    repository: repository),
                actions: actions)
            )
    }
    
    func makeSignUpViewController(actions: SignUpViewModelActions) -> UIViewController {
        let repository = DefaultProfileSettingsRepository(provider: dependencies.provider)
        let validator = NickNameValidator()
        return SignUpViewController(
            viewModel: SignUpViewModel(
                validateNickNameUseCase: DefaultValidateNicknameUseCase(
                    validator: validator),
                setupProfileUseCase: DefaultSetupProfileInfoUseCase(
                    repository: repository),
                actions: actions)
        )
    }
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager,
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
