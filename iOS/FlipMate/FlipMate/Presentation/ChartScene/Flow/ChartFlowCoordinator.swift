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
    func makeChartViewController() -> UIViewController
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
        let chartViewController = dependencies.makeChartViewController()
        navigationController.viewControllers = [chartViewController]
    }
}
