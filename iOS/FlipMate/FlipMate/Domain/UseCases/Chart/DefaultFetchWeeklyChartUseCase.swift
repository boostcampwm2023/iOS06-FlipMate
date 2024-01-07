//
//  DefaultFetchWeeklyChartUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

final class DefaultFetchWeeklyChartUseCase: FetchWeeklyChartUseCase {
    private let repository: ChartRepository
    
    init(repository: ChartRepository) {
        self.repository = repository
    }
    
    func fetchWeeklyChartLog() async throws -> WeeklyChartLog {
        return try await repository.fetchWeeklyLog()
    }
}
