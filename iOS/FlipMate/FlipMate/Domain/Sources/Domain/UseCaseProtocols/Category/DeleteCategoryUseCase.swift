//
//  DeleteCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol DeleteCategoryUseCase {
    func deleteCategory(of id: Int) async throws
}
