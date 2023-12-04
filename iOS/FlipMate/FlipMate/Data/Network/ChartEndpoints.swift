//
//  ChartEndpoints.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

struct ChartEndpoints {
    static func fetchDailyLog(date: Date) -> EndPoint<[DailyChartLogResponseDTO]> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.studylogs + "?date=\(date.dateToString(format: .yyyyMMdd))",
            method: .get)
        
    }
}
