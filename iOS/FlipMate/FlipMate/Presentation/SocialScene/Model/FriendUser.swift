//
//  FriendUser.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation

enum Section: CaseIterable {
    case main
}

struct FriendUser: Hashable {
    let profileImageURL: String?
    let name: String
    let time: Int?
    var isOnline: Bool
}
