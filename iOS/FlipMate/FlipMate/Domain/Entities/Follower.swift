//
//  Follower.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation

struct Follower: Hashable {
    let id: Int
    let nickName: String
    let profileImageURL: String?
    let isFollowing: Bool?
}
