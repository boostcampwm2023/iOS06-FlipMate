//
//  APIEndpoints.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

struct CategoryEndpoints {
    
    static func fetchCategories() -> EndPoint<[CategoryResponseDTO]> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.categories,
            method: .get)
    }
    
    static func createCategory(_ category: CategoryRequestDTO) -> EndPoint<CategoryResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(category)
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.categories,
            method: .post,
            data: data)
    }
    
    static func updateCategory(id: Int, category: CategoryRequestDTO) -> EndPoint<CategoryResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(category)
        let path = Paths.categories + "\\\(id)"
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: path,
            method: .patch,
            data: data)
    }
    
    static func deleteCategory(id: Int) -> EndPoint<StatusResponseDTO> {
        let path = Paths.categories + "\\\(id)"
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: path,
            method: .delete)
    }
}
