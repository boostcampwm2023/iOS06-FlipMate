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
    let id: Int?
    let profileImageURL: String?
    let name: String
    let totalTime: Int?
    let isStuding: Bool
}
