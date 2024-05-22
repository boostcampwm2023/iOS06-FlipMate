//
//  ReadCategoryUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol ReadCategoryUseCase {
    func readCategory() async throws -> [StudyCategory]
}
