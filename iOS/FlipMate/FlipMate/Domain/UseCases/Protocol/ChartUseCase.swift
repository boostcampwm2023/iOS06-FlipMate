//
//  ChartUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

protocol ChartUseCase {
    func fetchTodayChartLog() async throws -> ChartLog
    func fetchDailyChartLog(at date: Date) async throws -> ChartLog
}
