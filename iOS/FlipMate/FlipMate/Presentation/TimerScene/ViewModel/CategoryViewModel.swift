//
//  CategoryViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/16/23.
//

import Foundation
import Combine

struct CategoryViewModelActions {
    let showModifyCategory: (CategoryPurpose, Category?) -> Void
    let didFinishCategorySetting: () -> Void
}

protocol CategoryViewModelInput {
    func createCategoryTapped()
    func updateCategoryTapped(category: Category)
    func deleteCategory(of id: Int) async throws
    func didFinishCategorySetting()
    func cellDidTapped(category: Category)
}

protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
    var selectedCategoryPublisher: AnyPublisher<Category, Never> { get }
    var categoryPullPublisher: AnyPublisher<Void, Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    private var selectedCategorySubject = PassthroughSubject<Category, Never>()
    private var categoryPullSubject = PassthroughSubject<Void, Never>()
    
    private var categoryMananger: CategoryManagable
    private let deleteCategoryUseCase: DeleteCategoryUseCase
    private let actions: CategoryViewModelActions?
    private var selectedCategory: Category?
    
    init(deleteCategoryUseCase: DeleteCategoryUseCase, categoryManager: CategoryManagable, actions: CategoryViewModelActions? = nil) {
        self.deleteCategoryUseCase = deleteCategoryUseCase
        self.categoryMananger = categoryManager
        self.actions = actions
    }
    
    // MARK: Output
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoryMananger.categoryDidChangePublisher
    }
    
    var selectedCategoryPublisher: AnyPublisher<Category, Never> {
        return selectedCategorySubject.eraseToAnyPublisher()
    }
    
    var categoryPullPublisher: AnyPublisher<Void, Never> {
        return categoryPullSubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    func createCategoryTapped() {
        
        if categoryMananger.numberOfCategory() == 10 {
            categoryPullSubject.send()
        } else {
            actions?.showModifyCategory(.create, nil)
        }
    }
    
    func updateCategoryTapped(category: Category) {
        actions?.showModifyCategory(.update, category)
    }
    
    func didFinishCategorySetting() {
        actions?.didFinishCategorySetting()
    }

    func cellDidTapped(category: Category) {
        selectedCategory = category
        selectedCategorySubject.send(category)
//        categoryMananger.selectedCategory(category: category)
    }

    func deleteCategory(of id: Int) async throws {
        try await deleteCategoryUseCase.deleteCategory(of: id)
        categoryMananger.removeCategory(categoryId: id)
    }
}
