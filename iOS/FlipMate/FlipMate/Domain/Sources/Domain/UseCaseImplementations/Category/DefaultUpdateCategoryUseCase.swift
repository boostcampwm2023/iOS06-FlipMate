//
//  DefaultUpdateCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public final class DefaultUpdateCategoryUseCase: UpdateCategoryUseCsae {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func updateCategory(of id: Int, newName: String, newColorCode: String) async throws {
        try await repository.updateCategory(id: id, newName: newName, newColorCode: newColorCode)
    }
}
