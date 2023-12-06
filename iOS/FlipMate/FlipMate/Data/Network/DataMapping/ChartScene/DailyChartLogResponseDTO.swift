//
//  ChartLogResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

struct DailyChartLogResponseDTO: Decodable {
    let todayTime: Int
    let categories: [CategoryDTO]?
    let percentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case todayTime = "total_time"
        case categories
        case percentage
    }
}

extension DailyChartLogResponseDTO {
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
