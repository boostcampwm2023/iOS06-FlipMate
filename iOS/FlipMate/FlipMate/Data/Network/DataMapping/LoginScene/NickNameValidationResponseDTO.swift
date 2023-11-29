//
//  NickNameValidationResponseDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct NickNameValidationResponseDTO: Decodable {
    let isUnique: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isUnique = "is_unique"
    }
}
