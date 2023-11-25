//
//  TimerFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

protocol TimerFlowCoordinatorDependencies {
    func makeTimerViewController() -> TimerViewController
}

final class TimerFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private weak var navigationController: UINavigationController?
    private let dependencies: TimerFlowCoordinatorDependencies
    
    private weak var timerViewController: TimerViewController?
    
    init(navigationController: UINavigationController? = nil, dependencies: TimerFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeTimerViewController()
        navigationController?.viewControllers = [viewController]
        timerViewController = viewController
    }
}
