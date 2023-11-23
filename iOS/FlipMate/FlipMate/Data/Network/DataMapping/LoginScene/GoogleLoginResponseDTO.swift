//
//  GoogleLoginResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

struct GoogleLoginResponseDTO: Decodable {
    let isMember: Bool
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case isMember = "is_member"
        case accessToken = "access_token"
    }
}
