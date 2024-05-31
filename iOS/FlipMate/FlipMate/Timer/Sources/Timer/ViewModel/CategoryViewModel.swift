//
//  CategoryViewModel.swift
//  
//
//  Created by 권승용 on 5/30/24.
//

import Foundation
import Combine

import Domain

struct CategoryViewModelActions {
    let showModifyCategory: (CategoryPurpose, StudyCategory?) -> Void
    let didFinishCategorySetting: () -> Void
}

protocol CategoryViewModelInput {
    func createCategoryTapped()
    func updateCategoryTapped(category: StudyCategory)
    func deleteCategory(of id: Int) async throws
    func didFinishCategorySetting()
    func cellDidTapped(category: StudyCategory)
}

protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[StudyCategory], Never> { get }
    var selectedCategoryPublisher: AnyPublisher<StudyCategory, Never> { get }
    var categoryPullPublisher: AnyPublisher<Void, Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[StudyCategory], Never>([])
    private var selectedCategorySubject = PassthroughSubject<StudyCategory, Never>()
    private var categoryPullSubject = PassthroughSubject<Void, Never>()
    
    private var categoryMananger: CategoryManageable
    private let deleteCategoryUseCase: DeleteCategoryUseCase
    private let actions: CategoryViewModelActions?
    private var selectedCategory: StudyCategory?
    
    init(deleteCategoryUseCase: DeleteCategoryUseCase, categoryManager: CategoryManageable, actions: CategoryViewModelActions? = nil) {
        self.deleteCategoryUseCase = deleteCategoryUseCase
        self.categoryMananger = categoryManager
        self.actions = actions
    }
    
    // MARK: Output
    var categoriesPublisher: AnyPublisher<[StudyCategory], Never> {
        return categoryMananger.categoryDidChangePublisher
    }
    
    var selectedCategoryPublisher: AnyPublisher<StudyCategory, Never> {
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
    
    func updateCategoryTapped(category: StudyCategory) {
        actions?.showModifyCategory(.update, category)
    }
    
    func didFinishCategorySetting() {
        actions?.didFinishCategorySetting()
    }
    
    func cellDidTapped(category: StudyCategory) {
        selectedCategory = category
        selectedCategorySubject.send(category)
        //        categoryMananger.selectedCategory(category: category)
    }
    
    func deleteCategory(of id: Int) async throws {
        try await deleteCategoryUseCase.deleteCategory(of: id)
        categoryMananger.removeCategory(categoryId: id)
    }
}
