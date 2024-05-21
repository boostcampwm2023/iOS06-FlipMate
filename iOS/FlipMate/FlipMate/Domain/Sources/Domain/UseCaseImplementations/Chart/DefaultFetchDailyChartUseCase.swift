//
//  DefaultFetchDailyChartUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation

public final class DefaultFetchDailyChartUseCase: FetchDailyChartUseCase {
    private let repository: ChartRepository
    
    public init(repository: ChartRepository) {
        self.repository = repository
    }
    
    public func fetchDailyChartLog(at date: Date) async throws -> CategoryChartLog {
        var chartLog = try await repository.fetchDailyLog(date: date)
        
        var etcTime = chartLog.studyLog.category.reduce(0) { (result, category) in
            return result + (category.studyTime ?? 0)
        }
        
        etcTime = chartLog.studyLog.totalTime - etcTime
        
        let etcCategory = Category(id: 0, color: "888888FF", subject: NSLocalizedString("etc", comment: ""), studyTime: etcTime)
        chartLog.studyLog.category.append(etcCategory)
        
        return chartLog
    }
}
