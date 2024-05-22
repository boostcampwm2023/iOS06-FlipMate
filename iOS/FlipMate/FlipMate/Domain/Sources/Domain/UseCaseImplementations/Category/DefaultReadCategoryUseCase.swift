//
//  DefaultReadCategoryUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public final class DefaultReadCategoryUseCase: ReadCategoryUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func readCategory() async throws -> [StudyCategory] {
        return try await repository.readCategories()
    }
}
