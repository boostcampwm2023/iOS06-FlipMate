//
//  DefaultCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

class DefaultCategoryUseCase: CategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    func createCategory(with category: Category) async throws {
        try await repository.createCategory(category)
    }
    
    func updateCategory(of id: Int, to category: Category) async throws {
        try await repository.updateCategory(id: id, to: category)
    }
    
    func deleteCategory(of id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
