//
//  ChartFlowCoordinator.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation
import UIKit

protocol ChartFlowCoordinatorDependencies {
    func makeChartFlowCoordinator(navigationController: UINavigationController) -> ChartFlowCoordinator
    func makeChartViewController(actions: ChartViewModelActions) -> UIViewController
}

final class ChartFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private var dependencies: ChartFlowCoordinatorDependencies
    
    init(dependencies: ChartFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = ChartViewModelActions()
        let chartViewController = dependencies.makeChartViewController(actions: actions)
        navigationController.viewControllers = [chartViewController]
    }
}

