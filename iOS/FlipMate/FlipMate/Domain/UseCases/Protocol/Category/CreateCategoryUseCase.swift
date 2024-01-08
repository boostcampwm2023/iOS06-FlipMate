//
//  CategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

protocol CreateCategoryUseCase {
    func createCategory(name: String, colorCode: String) async throws -> Int
}
