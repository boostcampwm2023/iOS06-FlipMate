//
//  StudyLogResponseDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation

struct StudyLogResponseDTO: Decodable {
    let todayTime: Int
    let categories: [CategoryDTO]
    
    private enum CodingKeys: String, CodingKey {
        case todayTime = "today_time"
        case categories
    }
    
    func toEntity() -> StudyLog {
        return .init(
            totalTime: todayTime,
            category: categories.map {
                Category(id: $0.id, color: $0.color, subject: $0.name, studyTime: $0.todayTime)
            }
        )
    }
}

extension StudyLogResponseDTO {
    struct CategoryDTO: Decodable {
        let id: Int
        let name: String
        let color: String
        let todayTime: Int
        
        private enum CodingKeys: String, CodingKey {
            case id = "category_id"
            case name, color
            case todayTime = "today_time"
        }
    }
}
