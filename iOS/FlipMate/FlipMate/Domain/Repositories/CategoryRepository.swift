//
//  CategoryRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

protocol CategoryRepository {
    func createCategory(_ newCategory: Category) async throws
    func readCategories() async throws -> [Category]
    func updateCategory(id: Int, to newCategory: Category) async throws
    func deleteCategory(id: Int) async throws
}
