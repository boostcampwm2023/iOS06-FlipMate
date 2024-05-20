//
//  ChartRepository.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public protocol ChartRepository {
    func fetchDailyLog(date: Date) async throws -> CategoryChartLog
    func fetchWeeklyLog() async throws -> WeeklyChartLog
}
