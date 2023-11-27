//
//  TimerFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

protocol TimerFlowCoordinatorDependencies {
    func makeTimerViewController(actions: TimerViewModelActions) -> TimerViewController
    func makeCategoryDIContainer() -> CategoryDIContainer
}

final class TimerFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: TimerFlowCoordinatorDependencies
        
    init(navigationController: UINavigationController, dependencies: TimerFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = TimerViewModelActions(
            showCategorySettingViewController: showCategorySettingViewController)
        let viewController = dependencies.makeTimerViewController(actions: actions)
        navigationController.viewControllers = [viewController]
    }
    
    private func showCategorySettingViewController() {
        let categoryDIContainer = dependencies.makeCategoryDIContainer()
        let coordinator = categoryDIContainer.makeCategoryFlowCoordinator(
            navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
