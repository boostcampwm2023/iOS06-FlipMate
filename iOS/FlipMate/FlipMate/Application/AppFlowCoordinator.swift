//
//  AppFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

final class AppFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    // TODO: 추후 자동 로그인 로직 추가
    var isLogginIn: Bool = false
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        if isLogginIn {
            showTimerViewController()
        } else {
            showLoginViewController()
        }
    }

    private func showLoginViewController() {
        let loginDIContainer = appDIContainer.makeLoginDiContainer()
        let coordinator = loginDIContainer.makeLoginFlowCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    private func showTimerViewController() {
        let timerSceneDIContainer = appDIContainer.makeTimerSceneDIContainer()
        let coordinator = timerSceneDIContainer.makeTimerFlowCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
