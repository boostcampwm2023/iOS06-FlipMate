//
//  CategoryModifyViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Foundation
import Combine

struct CategoryModifyViewModelActions {
    let didFinishCategoryModify: () -> Void
}

protocol CategoryModifyViewModelInput {
    func createCategory(name: String, colorCode: String?) async throws
    func updateCategory(newName: String, newColorCode: String?) async throws
    func modifyCloseButtonTapped()
    func modifyDoneButtonTapped()
    func performCategoryModification(purpose: CategoryPurpose, name: String, colorCode: String?) async throws
}

protocol CategoryModifyViewModelOutput {
    var selectedCategoryPublisher: AnyPublisher<Category?, Never> { get }
}

typealias CategoryModifyViewModelProtocol = CategoryModifyViewModelInput & CategoryModifyViewModelOutput

final class CategoryModifyViewModel: CategoryModifyViewModelProtocol {
    
    // MARK: - Subject
    private lazy var selectedCategorySubject = CurrentValueSubject<Category?, Never>(selectedCategory)
    
    // MARK: - Properites
    private var categoryMananger: CategoryManagable
    private let createCategoryUseCase: CreateCategoryUseCase
    private let updateCategoryUseCase: UpdateCategoryUseCsae
    private let actions: CategoryModifyViewModelActions?
    private let selectedCategory: Category?
    
    // MARK: - init
    
    init(createCategoryUseCase: CreateCategoryUseCase,
         updateCategoryUseCase: UpdateCategoryUseCsae,
         categoryManager: CategoryManagable,
         actions: CategoryModifyViewModelActions? = nil,
         selectedCategory: Category? = nil) {
        self.createCategoryUseCase = createCategoryUseCase
        self.updateCategoryUseCase = updateCategoryUseCase
        self.categoryMananger = categoryManager
        self.actions = actions
        self.selectedCategory = selectedCategory
    }
    
    // MARK: - Output
    var selectedCategoryPublisher: AnyPublisher<Category?, Never> {
        return selectedCategorySubject.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    func createCategory(name: String, colorCode: String?) async throws {
        let colorCode = colorCode ?? "000000FF"
        let newCategoryID = try await createCategoryUseCase.createCategory(name: name, colorCode: colorCode)
        let newCategory = Category(id: newCategoryID, color: colorCode, subject: name, studyTime: 0)
        categoryMananger.append(category: newCategory)
    }
    
    func updateCategory(newName: String, newColorCode: String?) async throws {
        guard let selectedCategory = selectedCategory else { return FMLogger.general.error("선택된 카테고리 없음")}
        let colorCode = newColorCode ?? "000000FF", studyTime = selectedCategory.studyTime ?? 0
        try await updateCategoryUseCase.updateCategory(of: selectedCategory.id, newName: newName, newColorCode: colorCode)
        let updateCategory = Category(id: selectedCategory.id, color: colorCode, subject: newName, studyTime: studyTime)
        categoryMananger.change(category: updateCategory)
    }
    
    func modifyDoneButtonTapped() {
        actions?.didFinishCategoryModify()
    }
    
    func modifyCloseButtonTapped() {
        actions?.didFinishCategoryModify()
    }
    
    func performCategoryModification(purpose: CategoryPurpose, name: String, colorCode: String?) async throws {
        do {
            switch purpose {
            case .create:
                try await createCategory(name: name, colorCode: colorCode)
            case .update:
                try await updateCategory(newName: name, newColorCode: colorCode)
            }
            modifyDoneButtonTapped()
        } catch let error as APIError {
            FMLogger.general.error("카테고리 에러 \(error)")
            switch error {
            case .errorResponse(let response):
                switch response.statusCode {
                case 400: throw CategoryModificationError.duplicatedName
                default: throw CategoryModificationError.unknownError
                }
            }
        }
    }
}

enum CategoryModificationError: Error {
    case duplicatedName
    case unknownError
}
