//
//  DefaultFetchWeeklyChartUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

public final class DefaultFetchWeeklyChartUseCase: FetchWeeklyChartUseCase {
    private let repository: ChartRepository
    
    public init(repository: ChartRepository) {
        self.repository = repository
    }
    
    public func fetchWeeklyChartLog(at date: Date) async throws -> WeeklyChartLog {
        return try await repository.fetchWeeklyLog()
    }
}
