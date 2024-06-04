//
//  LoginFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit
import Login

protocol LoginFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController
    func makeSignUpViewController(actions: SignUpViewModelActions) -> UIViewController
    func makeTabBarDIContainer() -> TabBarDIContainer
}

final class LoginFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    weak var navigationViewController: UINavigationController?
    private let dependencies: LoginFlowCoordinatorDependencies
    
    init(navigationViewController: UINavigationController, dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationViewController = navigationViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(
            showSignUpViewController: showSignUpController,
            showTabBarController: showTabBarController,
            skippedLogin: showTabBarController
        )
        let viewController = dependencies.makeLoginViewController(actions: actions)
        navigationViewController?.viewControllers = [viewController]
    }
    
    private func showSignUpController() {
        let actions = SignUpViewModelActions(
            didFinishSignUp: showTabBarController)
        let signUpController = dependencies.makeSignUpViewController(actions: actions)
        navigationViewController?.pushViewController(signUpController, animated: true)
    }
    
    private func showTabBarController() {
        let tabBarDIContainer = dependencies.makeTabBarDIContainer()
        let coordinator = tabBarDIContainer.makeTabBarFlowCoordinator(
            navigationController: navigationViewController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
