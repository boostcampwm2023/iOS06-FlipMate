//
//  TimerFinishRequestDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/21/23.
//

import Foundation

struct TimerFinishRequestDTO: Encodable {
    let date: String
    let createdAt: String
    let type: String
    let learningTime: Int
    let categoryID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case date
        case createdAt = "created_at"
        case type
        case learningTime = "learning_time"
        case categoryID = "category_id"
    }
}
