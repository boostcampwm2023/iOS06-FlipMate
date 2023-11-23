//
//  GoogleLoginRequestDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

struct GoogleLoginRequestDTO: Encodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
