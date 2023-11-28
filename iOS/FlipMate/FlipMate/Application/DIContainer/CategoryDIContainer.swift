//
//  CategoryDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

final class CategoryDIContainer: CategoryFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManageable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCategoryViewModel(actions: CategoryViewModelActions? = nil) -> CategoryViewModelProtocol {
        return CategoryViewModel(
            useCase: DefaultCategoryUseCase(
                repository: DefaultCategoryRepository(
                    provider: dependencies.provider)),
            categoryManager: dependencies.categoryManager,
            actions: actions
        )
    }
    
    func makeCategorySettingViewController(actions: CategoryViewModelActions) -> UIViewController {
        return CategorySettingViewController(viewModel: makeCategoryViewModel(actions: actions))
    }
    
    func makeCategoryModifyViewController(
        purpose: CategoryPurpose,
        category: Category? = nil,
        actions: CategoryViewModelActions
    ) -> UIViewController {
        return CategoryModifyViewController(
            viewModel: makeCategoryViewModel(actions: actions),
            purpose: purpose,
            category: category)
    }
    
    func makeCategoryFlowCoordinator(
        navigationController: UINavigationController
    ) -> CategoryFlowCoordinator {
        return CategoryFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
}
