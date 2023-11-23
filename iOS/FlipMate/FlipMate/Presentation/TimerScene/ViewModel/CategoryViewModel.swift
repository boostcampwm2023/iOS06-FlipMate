//
//  CategoryViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/16/23.
//

import Foundation
import Combine

protocol CategoryViewModelInput {
    func createCategoryTapped()
    func createCategory(_ sender: Category) async throws
    func readCategories() async throws
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(of id: Int) async throws
}

protocol CategoryViewModelOutput {
    var presentingCategoryModifyViewControllerPublisher: AnyPublisher<Void, Never> { get }
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: properties
    private var presentingCategoryModifyViewControllerSubject = PassthroughSubject<Void, Never>()
    private var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    var categories = [Category]()
    
    private let useCase: CategoryUseCase
    
    init(useCase: CategoryUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Output
    var presentingCategoryModifyViewControllerPublisher: AnyPublisher<Void, Never> {
        return presentingCategoryModifyViewControllerSubject
            .eraseToAnyPublisher()
    }
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoriesSubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    func createCategoryTapped() {
        presentingCategoryModifyViewControllerSubject.send()
    }
    
    func createCategory(_ sender: Category) async throws {
        try await useCase.createCategory(name: sender.subject, colorCode: sender.color)
        categories.append(sender)
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
