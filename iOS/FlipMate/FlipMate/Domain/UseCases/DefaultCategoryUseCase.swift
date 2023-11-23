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
    
    func createCategory(name: String, colorCode: String) async throws {
        try await repository.createCategory(name: name, colorCode: colorCode)
    }
    
    func readCategory() async throws -> [Category] {
        return try await repository.readCategories()
    }
    
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await repository.updateCategory(id: id, newName: newName, newColorCode: newColorCode)
    }
    
    func deleteCategory(of id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
