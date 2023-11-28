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
    let didFinishCategoryModify: () -> Void
}

protocol CategoryViewModelInput {
    func createCategoryTapped()
    func updateCategoryTapped(category: Category)
    func createCategory(name: String, colorCode: String) async throws
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(of id: Int) async throws
    func didFinishCategorySetting()
    func modifyCloseButtonTapped()
    func modifyDoneButtonTapped()
}

protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    private var categoryMananger: CategoryManageable
    private let useCase: CategoryUseCase
    private let actions: CategoryViewModelActions?
    
    init(useCase: CategoryUseCase, categoryManager: CategoryManageable, actions: CategoryViewModelActions? = nil) {
        self.useCase = useCase
        self.categoryMananger = categoryManager
        self.actions = actions
    }
    
    // MARK: Output
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoryMananger.categoryDidChangePublisher
    }
    
    // MARK: Input
    func createCategoryTapped() {
        actions?.showModifyCategory(.create, nil)
    }
    
    func updateCategoryTapped(category: Category) {
        actions?.showModifyCategory(.update, category)
    }
    
    func didFinishCategorySetting() {
        actions?.didFinishCategorySetting()
    }
    
    func modifyDoneButtonTapped() {
        actions?.didFinishCategoryModify()
    }
    
    func modifyCloseButtonTapped() {
        actions?.didFinishCategoryModify()
    }
    
    func createCategory(name: String, colorCode: String) async throws {
        let newCategoryID = try await useCase.createCategory(name: name, colorCode: colorCode)
        let newCategory = Category(id: newCategoryID, color: colorCode, subject: name)
        categoryMananger.append(category: newCategory)
    }
    
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await useCase.updateCategory(of: id, newName: newName, newColorCode: newColorCode)
        let updateCategory = Category(id: id, color: newColorCode, subject: newName)
        categoryMananger.change(category: updateCategory)
    }
    
    func deleteCategory(of id: Int) async throws {
        try await useCase.deleteCategory(of: id)
        categoryMananger.removeCategory(categoryId: id)
    }
}
