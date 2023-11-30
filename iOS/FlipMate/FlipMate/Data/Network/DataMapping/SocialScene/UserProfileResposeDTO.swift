//
//  UserProfileResposeDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation

struct UserProfileResposeDTO: Decodable {
    let profileImageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case profileImageURL = "image_url"
    }
}
