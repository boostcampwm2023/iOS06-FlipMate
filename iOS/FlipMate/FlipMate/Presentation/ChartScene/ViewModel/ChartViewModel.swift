//
//  ChartViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import Foundation
import Combine

protocol ChartViewModelInput {
    func viewDidLoad()
    func dateDidSelected(date: Date)
}

protocol ChartViewModelOutput {
    var dailyChartPublisher: AnyPublisher<StudyLog, Never> { get }
    var weeklyChartPulisher: AnyPublisher<[DailyData], Never> { get }
}

typealias ChartViewModelProtocol = ChartViewModelInput & ChartViewModelOutput

final class ChartViewModel: ChartViewModelProtocol {
    
    // MARK: - Properties
    private var selectedDate = Date()
    
    // MARK: - UseCase
    private let dailyChartUseCase: FetchDailyChartUseCase
    private let weeklyChartUseCase: FetchWeeklyChartUseCase

    // MARK: - Subject
    private let dailyChartSubject = PassthroughSubject<StudyLog, Never>()
    private let weeklyChartSubject = PassthroughSubject<[DailyData], Never>()
    // MARK: - Publihser
    var dailyChartPublisher: AnyPublisher<StudyLog, Never> {
        return dailyChartSubject.eraseToAnyPublisher()
    }
    
    var weeklyChartPulisher: AnyPublisher<[DailyData], Never> {
        return weeklyChartSubject.eraseToAnyPublisher()
    }
    
    init(dailyChartUseCase: FetchDailyChartUseCase,
         weeklyChartUseCase: FetchWeeklyChartUseCase) {
        self.dailyChartUseCase = dailyChartUseCase
        self.weeklyChartUseCase = weeklyChartUseCase
    }
    
    // MARK: - input
    func viewDidLoad() {
        fetchWeeklyChartLog(at: selectedDate)
    }
    
    func dateDidSelected(date: Date) {
        selectedDate = date
        fetchDailyChartLog(at: selectedDate)
    }
}

private extension ChartViewModel {
    func fetchDailyChartLog(at date: Date) {
        Task {
            let log = try await dailyChartUseCase.fetchDailyChartLog(at: date)
            dailyChartSubject.send(log.studyLog)
        }
    }
    
    func fetchWeeklyChartLog(at date: Date) {
        Task {
            let log = try await weeklyChartUseCase.fetchWeeklyChartLog(at: date)
            weeklyChartSubject.send(log.dailyData)
        }
    }
}
