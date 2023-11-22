//
//  CategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

protocol CategoryUseCase {
    func createCategory(with category: Category) async throws
    func updateCategory(of id: Int, to category: Category) async throws
    func deleteCategory(of id: Int) async throws
}
