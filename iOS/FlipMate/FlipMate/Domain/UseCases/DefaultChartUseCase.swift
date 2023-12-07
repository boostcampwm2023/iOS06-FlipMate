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
    
    func fetchDailyChartLog(at date: Date) async throws -> CategoryChartLog {
        var chartLog = try await repository.fetchDailyLog(date: date)
        
        var etcTime = chartLog.studyLog.category.reduce(0) { (result, category) in
            return result + (category.studyTime ?? 0)
        }
        
        etcTime = chartLog.studyLog.totalTime - etcTime
        
        let etcCategory = Category(id: 0, color: "888888FF", subject: "기타", studyTime: etcTime)
            chartLog.studyLog.category.append(etcCategory)
        
        return chartLog
    }
    
    func fetchWeeklyChartLog() async throws -> WeeklyChartLog {
        return try await repository.fetchWeeklyLog()
    }
}
