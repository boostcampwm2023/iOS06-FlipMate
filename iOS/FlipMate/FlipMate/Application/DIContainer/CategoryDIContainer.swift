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
        let categoryManager: CategoryManager
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCategorySettingViewController() -> UIViewController {
        return CategorySettingViewController(
            viewModel: CategoryViewModel(
                useCase: DefaultCategoryUseCase(
                    repository: DefaultCategoryRepository(
                        provider: dependencies.provider))))
    }
    
    func makeCategoryFlowCoordinator(navigationController: UINavigationController) -> CategoryFlowCoordinator {
        return CategoryFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
}
