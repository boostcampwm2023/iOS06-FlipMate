//
//  CategoryRepository.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public protocol CategoryRepository {
    func createCategory(name: String, colorCode: String) async throws -> Int
    func readCategories() async throws -> [StudyCategory]
    func updateCategory(id: Int, newName: String, newColorCode: String) async throws
    func deleteCategory(id: Int) async throws
}
