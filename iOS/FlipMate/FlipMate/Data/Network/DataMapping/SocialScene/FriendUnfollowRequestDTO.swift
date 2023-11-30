//
//  FriendUnfollowRequestDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation

struct FriendUnfollowRequestDTO: Encodable {
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "following_id"
    }
}
