//
//  CategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

protocol CategoryUseCase {
    func createCategory(name: String, colorCode: String) async throws -> Int
    func readCategory() async throws -> [Category]
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(of id: Int) async throws
}
