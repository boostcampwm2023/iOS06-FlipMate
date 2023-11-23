//
//  CategoryRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

protocol CategoryRepository {
    func createCategory(name: String, colorCode: String) async throws -> Int
    func readCategories() async throws -> [Category]
    func updateCategory(id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(id: Int) async throws
}
