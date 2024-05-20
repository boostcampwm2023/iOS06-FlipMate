//
//  DefaultCreateCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
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
