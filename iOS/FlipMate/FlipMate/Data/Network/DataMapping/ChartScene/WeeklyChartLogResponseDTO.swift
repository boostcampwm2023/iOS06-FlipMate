//
//  WeeklyChartLogResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 12/6/23.
//

import Foundation

struct WeeklyChartLogResponseDTO: Decodable {
    let totalTime: Int
    let dailyData: [Int]
    let primaryCategory: String?
    let percentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case totalTime = "total_time"
        case dailyData = "daily_data"
        case primaryCategory = "primary_category"
        case percentage
    }
}
