//
//  StudyLogResponseDTO.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation

import Domain

struct StudyLogResponseDTO: Decodable {
    let todayTime: Int
    let categories: [CategoryDTO]?
    
    private enum CodingKeys: String, CodingKey {
        case todayTime = "total_time"
        case categories
    }
    
    func toEntity() -> StudyLog {
        guard let categories = categories else { return .init(totalTime: todayTime, category: []) }
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
            case id
            case name
            case color = "color_code"
            case todayTime = "today_time"
        }
    }
}
