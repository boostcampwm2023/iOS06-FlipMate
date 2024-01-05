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

protocol ReadCategoryUseCase {
    func readCategory() async throws -> [Category]
}

protocol UpdateCategoryUseCsae {
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
}

protocol DeleteCategoryUseCase {
    func deleteCategory(of id: Int) async throws
}
