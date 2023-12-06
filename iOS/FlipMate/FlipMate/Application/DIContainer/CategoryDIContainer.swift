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
    
    func makeCategoryModifyViewModel(actions: CategoryModifyViewModelActions? = nil,
                                     selectedCategory: Category? = nil) -> CategoryModifyViewModelProtocol {
        return CategoryModifyViewModel(
            useCase: DefaultCategoryUseCase(
                repository: DefaultCategoryRepository(
                    provider: dependencies.provider)),
            categoryManager: dependencies.categoryManager,
            actions: actions,
            selectedCategory: selectedCategory
        )
    }
    
    func makeCategorySettingViewController(actions: CategoryViewModelActions) -> UIViewController {
        return CategorySettingViewController(viewModel: makeCategoryViewModel(actions: actions))
    }
    
    // TODO: CategoryModifyViewModel 만들어서 ViewController 생성
    func makeCategoryModifyViewController(
        purpose: CategoryPurpose,
        actions: CategoryModifyViewModelActions,
        selectedCategory: Category? = nil
    ) -> UIViewController {
        return CategoryModifyViewController(
            viewModel: makeCategoryModifyViewModel(
                actions: actions,
                selectedCategory: selectedCategory),
            purpose: purpose)
    }
    
    func makeCategoryFlowCoordinator(
        navigationController: UINavigationController?
    ) -> CategoryFlowCoordinator {
        return CategoryFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
}
