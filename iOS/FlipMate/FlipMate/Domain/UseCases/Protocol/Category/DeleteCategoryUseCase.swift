//
//  DeleteCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

protocol DeleteCategoryUseCase {
    func deleteCategory(of id: Int) async throws
}
