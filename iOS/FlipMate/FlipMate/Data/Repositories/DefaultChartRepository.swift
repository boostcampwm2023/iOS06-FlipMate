//
//  DefaultChartRepository.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation

final class DefaultChartRepository: ChartRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func fetchDailyLog(date: Date) async throws -> CategoryChartLog {
        let endpoint = ChartEndpoints.fetchDailyLog(date: date)
        let responseDTO = try await provider.request(with: endpoint)
        
        let categories = responseDTO.categories?.map { dto in
            return Category(id: dto.id, color: dto.color, subject: dto.name, studyTime: dto.todayTime)
        } ?? []
        
        return CategoryChartLog(studyLog: StudyLog(totalTime: responseDTO.todayTime, category: categories), percentage: responseDTO.percentage)
    }
    
    func fetchWeeklyLog() async throws -> WeeklyChartLog {
        let endpoint = ChartEndpoints.fetchWeeklyLog()
        let responseDTO = try await provider.request(with: endpoint)
        
        let transformedDailyData: [DailyData] = responseDTO.dailyData.enumerated().map { index, studyTime in
            let dayIndex = responseDTO.dailyData.count - 1 - index
            let dayOfWeekString = dayOfWeek(at: dateForDayIndex(dayIndex))
            return DailyData(day: dayOfWeekString, studyTime: studyTime)
        }
        
        return WeeklyChartLog(
            totalTime: responseDTO.totalTime,
            dailyData: transformedDailyData,
            primaryCategory: responseDTO.primaryCategory,
            percentage: responseDTO.percentage)
    }
}

private extension DefaultChartRepository {
    func dayOfWeek(at date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
    
    func dateForDayIndex(_ index: Int) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let day = calendar.date(byAdding: .day, value: -index, to: today) else {
            FMLogger.general.error("date 계산 실패")
            return Date()
        }
        return day
    }
}
