//
//  UserInfoResponseDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/04.
//

import Foundation

struct UserInfoResponseDTO: Decodable {
    let nickname: String
    let email: String
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case nickname
        case email
        case imageURL = "image_url"
    }
}
