//
//  CreateCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol CreateCategoryUseCase {
    func createCategory(name: String, colorCode: String) async throws -> Int
}
