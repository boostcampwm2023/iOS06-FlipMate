//
//  DefaultCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

final class DefaultCreateCategoryUseCase: CreateCategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func createCategory(name: String, colorCode: String) async throws -> Int {
        try await repository.createCategory(name: name, colorCode: colorCode)
    }
}

final class DefaultReadCategoryUseCase: ReadCategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func readCategory() async throws -> [Category] {
        return try await repository.readCategories()
    }
}

final class DefaultUpdateCategoryUseCase: UpdateCategoryUseCsae {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await repository.updateCategory(id: id, newName: newName, newColorCode: newColorCode)
    }
}

final class DefaultDeleteCategoryUseCase: DeleteCategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func deleteCategory(of id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
