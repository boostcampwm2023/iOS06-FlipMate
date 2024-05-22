//
//  DefaultCategoryRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

import Domain
import Network
import Core

public final class DefaultCategoryRepository: CategoryRepository {
    private let provider: Providable
    
    public init(provider: Providable) {
        self.provider = provider
    }
    
    public func createCategory(name: String, colorCode: String) async throws -> Int {
        let categoryDTO = CategoryRequestDTO(
            name: name,
            colorCode: colorCode)
        let endpoint = CategoryEndpoints.createCategory(categoryDTO)
        let createdCategory = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 생성 완료")
        return createdCategory.categoryID
    }
    
    public func readCategories() async throws -> [Category] {
        let endpoint = CategoryEndpoints.fetchCategories()
        let categories = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 읽기 완료")
        return categories.map { dto in
            Category(id: dto.categoryID, color: dto.colorCode, subject: dto.name, studyTime: nil)
        }
    }
    
    public func updateCategory(id: Int, newName: String, newColorCode: String) async throws {
        let categoryDTO = CategoryRequestDTO(
            name: newName,
            colorCode: newColorCode)
        let endpoint = CategoryEndpoints.updateCategory(id: id, category: categoryDTO)
        _ = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 업데이트 완료")
    }
    
    public func deleteCategory(id: Int) async throws {
        let endpoint = CategoryEndpoints.deleteCategory(id: id)
        _ = try await provider.request(with: endpoint)
        FMLogger.general.log("카테고리 삭제 완료")
    }
}
