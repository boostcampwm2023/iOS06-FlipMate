//
//  UpdateCategoryUseCsae.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol UpdateCategoryUseCsae {
    func updateCategory(of id: Int, newName: String, newColorCode: String) async throws
}
