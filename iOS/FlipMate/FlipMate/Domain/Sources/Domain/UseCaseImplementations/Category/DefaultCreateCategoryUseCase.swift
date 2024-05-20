//
//  DefaultCreateCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public final class DefaultCreateCategoryUseCase: CreateCategoryUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func createCategory(name: String, colorCode: String) async throws -> Int {
        try await repository.createCategory(name: name, colorCode: colorCode)
    }
}
