//
//  ChartViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation
import Combine

struct ChartViewModelActions {
    
}

final class ChartViewModel: ObservableObject {
    @Published var dailyChartLog: CategoryChartLog = .init(studyLog: StudyLog(totalTime: 0, category: []), percentage: 0)
    @Published var weeklyChartLog: WeeklyChartLog = .init(totalTime: 0, dailyData: [], percentage: 0)
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchDailyChartUseCase: FetchDailyChartUseCase
    private let fetchWeeklyChartUseCase: FetchWeeklyChartUseCase
    private let actions: ChartViewModelActions?
    
    init(fetchDailyChartUseCase: FetchDailyChartUseCase,
         fetchWeeklyChartUseCase: FetchWeeklyChartUseCase,
         actions: ChartViewModelActions? = nil) {
        self.fetchDailyChartUseCase = fetchDailyChartUseCase
        self.fetchWeeklyChartUseCase = fetchWeeklyChartUseCase
        self.actions = actions
    }
    
    func selectedDateDidChange(newDate: Date) async throws {
        try await fetchDailyData(date: newDate)
    }
    
    func fetchTodayData() async throws {
        let today = Date()
        try await fetchDailyData(date: today)
    }
    
    func showWeeklyChart() async throws {
        try await fetchWeeklyData()
    }
}

private extension ChartViewModel {
    func fetchDailyData(date: Date) async throws {
        let newDailyChartLog = try await fetchDailyChartUseCase.fetchDailyChartLog(at: date)
        DispatchQueue.main.async {
            self.dailyChartLog = newDailyChartLog
        }
    }
    
    func fetchWeeklyData() async throws {
        let newWeeklyChartLog = try await fetchWeeklyChartUseCase.fetchWeeklyChartLog()
        DispatchQueue.main.async {
            self.weeklyChartLog = newWeeklyChartLog
        }
    }
}
