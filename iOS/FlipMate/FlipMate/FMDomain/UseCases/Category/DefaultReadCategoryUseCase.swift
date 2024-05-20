//
//  DefaultReadCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultReadCategoryUseCase: ReadCategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func readCategory() async throws -> [Category] {
        return try await repository.readCategories()
    }
}
