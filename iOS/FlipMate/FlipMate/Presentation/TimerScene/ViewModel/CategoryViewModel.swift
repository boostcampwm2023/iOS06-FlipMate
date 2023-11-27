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
    func createCategory(name: String, colorCode: String) async throws
    func readCategories() async throws
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(of id: Int) async throws
    func didFinishCategorySetting()
}

protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    var categories = [Category]()
    private var categoryMananger: CategoryManager
    private let useCase: CategoryUseCase
    private let actions: CategoryViewModelActions?
    
    init(useCase: CategoryUseCase, categoryManager: CategoryManager, actions: CategoryViewModelActions? = nil) {
        self.useCase = useCase
        self.categoryMananger = categoryManager
        self.actions = actions
    }
    
    // MARK: Output
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoriesSubject.eraseToAnyPublisher()
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
    
    func createCategory(name: String, colorCode: String) async throws {
        let newCategoryID = try await useCase.createCategory(name: name, colorCode: colorCode)
        categories.append(Category(id: newCategoryID, color: colorCode, subject: name))
        categoriesSubject.send(categories)
    }
    
    func readCategories() async throws {
        categories = try await useCase.readCategory()
        categoriesSubject.send(categories)
    }
    
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await useCase.updateCategory(of: id, newName: newName, newColorCode: newColorCode)
        guard let index = categories.firstIndex(where: { $0.id == id }) else {
            FMLogger.general.error("일치하는 id를 가진 카테고리를 찾을 수 없음")
            return
        }
        
        categories[index] = Category(id: id, color: newColorCode, subject: newName)
        categoriesSubject.send(categories)
    }
    
    func deleteCategory(of id: Int) async throws {
        try await useCase.deleteCategory(of: id)
        guard let index = categories.firstIndex(where: { $0.id == id }) else {
            FMLogger.general.error("일치하는 id를 가진 카테고리를 찾을 수 없음")
            return
        }
        
        categories.remove(at: index)
        categoriesSubject.send(categories)
    }
}
