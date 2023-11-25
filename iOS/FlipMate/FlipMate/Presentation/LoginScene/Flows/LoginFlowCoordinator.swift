//
//  LoginFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol LoginFlowCoordinatorDependencies {
    func makeLoginViewController() -> LoginViewController
}

final class LoginFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private weak var navigationViewController: UINavigationController?
    private let dependencies: LoginFlowCoordinatorDependencies
    
    private weak var loginViewController: LoginViewController?
    
    init(navigationViewController: UINavigationController? = nil, dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationViewController = navigationViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeLoginViewController()
        navigationViewController?.viewControllers = [viewController]
        loginViewController = viewController
    }
}

