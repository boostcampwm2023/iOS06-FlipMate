//
//  TimerStartResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/21/23.
//

import Foundation

struct TimerStartResponseDTO: Decodable {
    let id: Int
    let date: String
    let createdAt: String
    let type: String
    let category: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case createdAt = "created_at"
        case type
        case category
    }
}
