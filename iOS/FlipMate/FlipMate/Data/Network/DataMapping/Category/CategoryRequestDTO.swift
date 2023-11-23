//
//  CategoryUpdateDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

struct CategoryRequestDTO: Encodable {
    let name: String
    let colorCode: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case colorCode = "color_code"
    }
}
