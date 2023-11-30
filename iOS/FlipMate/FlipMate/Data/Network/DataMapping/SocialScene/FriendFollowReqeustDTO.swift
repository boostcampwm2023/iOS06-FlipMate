//
//  FriendFollowReqeustDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation

struct FriendFollowReqeustDTO: Encodable {
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
        case nickname = "following_nickname"
    }
}

