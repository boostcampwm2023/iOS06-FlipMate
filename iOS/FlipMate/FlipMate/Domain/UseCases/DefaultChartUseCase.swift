//
//  DefaultChartUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

final class DefaultChartUseCase: ChartUseCase {
    private let repository: ChartRepository
    
    init(repository: ChartRepository) {
        self.repository = repository
    }
    
    func fetchTodayChartLog() async throws -> ChartLog {
        let date = Date()
        return try await repository.fetchDailyLog(date: date)
    }
    
    func fetchDailyChartLog(at date: Date) async throws -> ChartLog {
        return try await repository.fetchDailyLog(date: date)
    }
}
