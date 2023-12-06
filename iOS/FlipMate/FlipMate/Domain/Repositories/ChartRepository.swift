//
//  ChartRepository.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

protocol ChartRepository {
    func fetchDailyLog(date: Date) async throws -> CategoryChartLog
    func fetchWeeklyLog() async throws -> WeeklyChartLog
}
