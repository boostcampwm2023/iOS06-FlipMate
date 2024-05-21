//
//  FetchWeeklyChartUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol FetchWeeklyChartUseCase {
    func fetchWeeklyChartLog(at date: Date) async throws -> WeeklyChartLog
}
