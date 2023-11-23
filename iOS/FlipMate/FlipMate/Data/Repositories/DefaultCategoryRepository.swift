//
//  DefaultCategoryRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

final class DefaultCategoryRepository: CategoryRepository {
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func createCategory(_ newCategory: Category) async throws {
        let categoryDTO = CategoryRequestDTO(
            name: newCategory.subject,
            colorCode: newCategory.color)
        let endpoint = CategoryEndpoints.createCategory(categoryDTO)
        let createdCategory = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 생성 완료 : \(String(describing: createdCategory))")
    }
    
    func readCategories() async throws -> [Category] {
        let endpoint = CategoryEndpoints.fetchCategories()
        let categories = try await provider.request(with: endpoint)
        return categories.map { dto in
            Category(id: dto.categoryID, color: dto.colorCode, subject: dto.name, studyTime: 0)
        }
    }
    
    func updateCategory(id: Int, to newCategory: Category) async throws {
        let categoryDTO = CategoryRequestDTO(
            name: newCategory.subject,
            colorCode: newCategory.color)
        let endpoint = CategoryEndpoints.updateCategory(id: id, category: categoryDTO)
        let updatedCategory = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 업데이트 완료 : \(String(describing: updatedCategory))")
    }
    
    func deleteCategory(id: Int) async throws {
        let endpoint = CategoryEndpoints.deleteCategory(id: id)
        let status = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 삭제 완료 : \(String(describing: status))")
    }
}
