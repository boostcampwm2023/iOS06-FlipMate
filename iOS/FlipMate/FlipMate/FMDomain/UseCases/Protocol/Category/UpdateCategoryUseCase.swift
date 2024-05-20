//
//  UpdateCategoryUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

protocol UpdateCategoryUseCsae {
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
}
