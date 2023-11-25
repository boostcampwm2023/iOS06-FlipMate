//
//  LoginFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol LoginFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController
    func makeTabBarDIContainer() -> TabBarDIContainer
}

final class LoginFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationViewController: UINavigationController
    private let dependencies: LoginFlowCoordinatorDependencies
        
    init(navigationViewController: UINavigationController, dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationViewController = navigationViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(showTabBarController: showTabBarController)
        let viewController = dependencies.makeLoginViewController(actions: actions)
//        navigationViewController.view.window?.rootViewController = viewController
        navigationViewController.viewControllers = [viewController]
    }
    
    private func showTabBarController() {
        let tabBarDIContainer = dependencies.makeTabBarDIContainer()
        let coordinator = tabBarDIContainer.makeTabBarFlowCoordinator(navigationController: navigationViewController)
        coordinator.start()
    }
}

