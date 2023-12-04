//
//  CategorySettingCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol CategoryFlowCoordinatorDependencies {
    func makeCategorySettingViewController(actions: CategoryViewModelActions) -> UIViewController
    func makeCategoryModifyViewController(
        purpose: CategoryPurpose,
        actions: CategoryModifyViewModelActions,
        selectedCategory: Category?) -> UIViewController
}

final class CategoryFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    private weak var navigationController: UINavigationController?
    private let dependencies: CategoryFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?, dependencies: CategoryFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = CategoryViewModelActions(
            showModifyCategory: showCategoryModifyVieWController,
            didFinishCategorySetting: didFinishCategorySetting)
        let viewController = dependencies.makeCategorySettingViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showCategoryModifyVieWController(purpose: CategoryPurpose, selectedCategory: Category? = nil) {
        let actions = CategoryModifyViewModelActions(
            didFinishCategoryModify: didFinishCategoryModify)
        let categoryModifyViewController = dependencies.makeCategoryModifyViewController(
            purpose: purpose,
            actions: actions,
            selectedCategory: selectedCategory)
        navigationController?.pushViewController(categoryModifyViewController, animated: true)
    }
    
    func didFinishCategorySetting() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishCategoryModify() {
        navigationController?.popViewController(animated: true)
    }
}
