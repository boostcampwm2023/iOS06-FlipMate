//
//  CategoryResponseDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

struct CategoryResponseDTO: Decodable {
    let id: Int
    let userID: Int
    let name: String
    let colorCode: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case colorCode = "color_code"
    }
}
