//
//  ChartViewModel.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Foundation
import Combine
import Domain

public protocol ChartViewModelInput {
    func viewDidLoad()
    func dateDidSelected(date: Date)
}

public protocol ChartViewModelOutput {
    var dailyChartPublisher: AnyPublisher<StudyLog, Never> { get }
    var weeklyChartPulisher: AnyPublisher<[DailyData], Never> { get }
}

public typealias ChartViewModelProtocol = ChartViewModelInput & ChartViewModelOutput

public final class ChartViewModel: ChartViewModelProtocol {
    
    // MARK: - Properties
    private var selectedDate = Date()
    
    // MARK: - UseCase
    private let dailyChartUseCase: FetchDailyChartUseCase
    private let weeklyChartUseCase: FetchWeeklyChartUseCase
    
    // MARK: - Subject
    private let dailyChartSubject = PassthroughSubject<StudyLog, Never>()
    private let weeklyChartSubject = PassthroughSubject<[DailyData], Never>()
    
    // MARK: - Publihser
    public var dailyChartPublisher: AnyPublisher<StudyLog, Never> {
        return dailyChartSubject.eraseToAnyPublisher()
    }
    
    public var weeklyChartPulisher: AnyPublisher<[DailyData], Never> {
        return weeklyChartSubject.eraseToAnyPublisher()
    }
    
    public init(dailyChartUseCase: FetchDailyChartUseCase,
         weeklyChartUseCase: FetchWeeklyChartUseCase) {
        self.dailyChartUseCase = dailyChartUseCase
        self.weeklyChartUseCase = weeklyChartUseCase
    }
    
    // MARK: - input
    public func viewDidLoad() {
        fetchDailyChartLog(at: selectedDate)
        fetchWeeklyChartLog(at: selectedDate)
    }
    
    public func dateDidSelected(date: Date) {
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
