//
//  ChartUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

protocol ChartUseCase {
    func fetchDailyChartLog(at date: Date) async throws -> CategoryChartLog
    func fetchWeeklyChartLog() async throws -> WeeklyChartLog
}
