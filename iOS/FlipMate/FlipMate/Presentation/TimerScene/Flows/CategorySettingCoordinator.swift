//
//  CategorySettingCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol CategoryFlowCoordinatorDependencies {
    func makeCategorySettingViewController(actions: CategoryViewModelActions) -> UIViewController
    func makeCategoryModifyViewController(purpose: CategoryPurpose, category: Category?) -> UIViewController
}

final class CategoryFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    private var navigationController: UINavigationController
    private let dependencies: CategoryFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: CategoryFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = CategoryViewModelActions(
            showModifyCategory: showCategoryModifyVieWController,
            didFinishCategorySetting: didFinishCategorySetting
        )
        let viewController = dependencies.makeCategorySettingViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showCategoryModifyVieWController(purpose: CategoryPurpose, category: Category? = nil) {
        let categoryModifyViewController = dependencies.makeCategoryModifyViewController(purpose: purpose, category: category)
        navigationController.pushViewController(categoryModifyViewController, animated: true)
    }
    
    func didFinishCategorySetting() {
        parentCoordinator?.childDidFinish(self)
    }
}
