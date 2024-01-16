//
//  FollowerFriendResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation

struct FollowerFriendResponseDTO: Decodable {
    let id: Int
    let nickname: String
    let imageUrl: String
    let isFollowed: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case imageUrl = "image_url"
        case isFollowed = "is_followed"
    }
}
