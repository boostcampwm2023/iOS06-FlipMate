//
//  SignUpResponseDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let nickName: String
    let email: String
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case nickName = "nickname"
        case email
        case imageURL = "image_url"
    }
}
