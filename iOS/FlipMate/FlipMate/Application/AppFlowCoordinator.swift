//
//  AppFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

final class AppFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        var isLoggedIn: Bool
        
        if let token = try? KeychainManager.getAccessToken() {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        if isLoggedIn {
            showTabBarViewController()
        } else {
            showLoginViewController()
        }        
    }

    private func showLoginViewController() {
        let loginDIContainer = appDIContainer.makeLoginDiContainer()
        let coordinator = loginDIContainer.makeLoginFlowCoordinator(
            navigationController: navigationController)
        coordinator.start()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    private func showTabBarViewController() {
        let tabBarDIContainer = appDIContainer.makeTabBarDIContainer()
        let coordinator = tabBarDIContainer.makeTabBarFlowCoordinator(
            navigationController: navigationController)
        coordinator.start()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
}
