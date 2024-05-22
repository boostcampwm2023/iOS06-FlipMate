//
//  AppleAuthRequestDTO.swift
//  FlipMate
//
//  Created by 권승용 on 12/14/23.
//

import Foundation

struct AppleAuthRequestDTO: Encodable {
    let identityToken: String
    
    private enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
    }
}
