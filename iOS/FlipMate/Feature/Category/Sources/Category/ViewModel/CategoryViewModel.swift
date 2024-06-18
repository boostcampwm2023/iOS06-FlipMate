//
//  CategoryViewModel.swift
//  
//
//  Created by 권승용 on 5/30/24.
//

import Foundation
import Combine

import Domain
import CategoryService

public struct CategoryViewModelActions {
    let showModifyCategory: (CategoryPurpose, StudyCategory?) -> Void
    let didFinishCategorySetting: () -> Void
    
    public init(showModifyCategory: @escaping (CategoryPurpose, StudyCategory?) -> Void, didFinishCategorySetting: @escaping () -> Void) {
        self.showModifyCategory = showModifyCategory
        self.didFinishCategorySetting = didFinishCategorySetting
    }
}

public protocol CategoryViewModelInput {
    func createCategoryTapped()
    func updateCategoryTapped(category: StudyCategory)
    func deleteCategory(of id: Int) async throws
    func didFinishCategorySetting()
    func cellDidTapped(category: StudyCategory)
}

public protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[StudyCategory], Never> { get }
    var selectedCategoryPublisher: AnyPublisher<StudyCategory, Never> { get }
    var categoryPullPublisher: AnyPublisher<Void, Never> { get }
}

public typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

public final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[StudyCategory], Never>([])
    private var selectedCategorySubject = PassthroughSubject<StudyCategory, Never>()
    private var categoryPullSubject = PassthroughSubject<Void, Never>()
    
    private var categoryMananger: CategoryManageable
    private let deleteCategoryUseCase: DeleteCategoryUseCase
    private let actions: CategoryViewModelActions?
    private var selectedCategory: StudyCategory?
    
    public init(deleteCategoryUseCase: DeleteCategoryUseCase, categoryManager: CategoryManageable, actions: CategoryViewModelActions? = nil) {
        self.deleteCategoryUseCase = deleteCategoryUseCase
        self.categoryMananger = categoryManager
        self.actions = actions
    }
    
    // MARK: Output
    public var categoriesPublisher: AnyPublisher<[StudyCategory], Never> {
        return categoryMananger.categoryDidChangePublisher
    }
    
    public var selectedCategoryPublisher: AnyPublisher<StudyCategory, Never> {
        return selectedCategorySubject.eraseToAnyPublisher()
    }
    
    public var categoryPullPublisher: AnyPublisher<Void, Never> {
        return categoryPullSubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    public func createCategoryTapped() {
        
        if categoryMananger.numberOfCategory() == 10 {
            categoryPullSubject.send()
        } else {
            actions?.showModifyCategory(.create, nil)
        }
    }
    
    public func updateCategoryTapped(category: StudyCategory) {
        actions?.showModifyCategory(.update, category)
    }
    
    public func didFinishCategorySetting() {
        actions?.didFinishCategorySetting()
    }
    
    public func cellDidTapped(category: StudyCategory) {
        selectedCategory = category
        selectedCategorySubject.send(category)
        //        categoryMananger.selectedCategory(category: category)
    }
    
    public func deleteCategory(of id: Int) async throws {
        try await deleteCategoryUseCase.deleteCategory(of: id)
        categoryMananger.removeCategory(categoryId: id)
    }
}
