//
//  FreindStatusResponseDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/02.
//

import Foundation

struct FriendStatusResponseDTO: Decodable {
    let id: Int
    let startedTime: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case startedTime = "started_at"
    }
}
