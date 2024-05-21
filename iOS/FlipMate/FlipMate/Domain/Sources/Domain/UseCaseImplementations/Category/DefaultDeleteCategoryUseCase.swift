//
//  DefaultDeleteCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public final class DefaultDeleteCategoryUseCase: DeleteCategoryUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func deleteCategory(of id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
