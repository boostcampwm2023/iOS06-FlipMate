//
//  Friend.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation

struct Friend: Hashable {
    let id: Int
    let nickName: String
    let profileImageURL: String?
    let totalTime: Int
    let startedTime: String?
    let isStuding: Bool
}
