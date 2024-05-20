//
//  DefaultDeleteCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultDeleteCategoryUseCase: DeleteCategoryUseCase {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func deleteCategory(of id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
