//
//  FriendChartRequestDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation

struct SocialDetailRequestDTO: Encodable {
    let followingID: Int
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case followingID = "following_id"
    }
}
