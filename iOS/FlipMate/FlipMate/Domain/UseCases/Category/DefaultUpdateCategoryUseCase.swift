//
//  DefaultUpdateCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultUpdateCategoryUseCase: UpdateCategoryUseCsae {
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await repository.updateCategory(id: id, newName: newName, newColorCode: newColorCode)
    }
}
