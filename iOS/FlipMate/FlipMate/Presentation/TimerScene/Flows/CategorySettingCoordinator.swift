//
//  CategorySettingCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol CategoryFlowCoordinatorDependencies {
    func makeCategorySettingViewController() -> UIViewController
}

final class CategoryFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: CategoryFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: CategoryFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeCategorySettingViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showCategoryModifyVieWController() {
        
    }
}
