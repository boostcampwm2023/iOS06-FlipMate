//
//  FriendsResponseDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation

struct FriendsResponseDTO: Decodable {
    var id: Int
    var nickname: String
    var imageURL: String?
    var totalTime: Int
    var startTime: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, nickname
        case imageURL = "image_url"
        case totalTime = "total_time"
        case startTime = "started_at"
    }
}
