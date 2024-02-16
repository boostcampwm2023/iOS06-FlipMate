//
//  FetchWeeklyChartUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

protocol FetchWeeklyChartUseCase {
    func fetchWeeklyChartLog(at date: Date) async throws -> WeeklyChartLog
}
