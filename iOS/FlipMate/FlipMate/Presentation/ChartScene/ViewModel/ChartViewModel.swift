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
}

protocol ChartViewModelOutput {
    var dailyChartPublisher: AnyPublisher<StudyLog, Never> { get }
}

typealias ChartViewModelProtocol = ChartViewModelInput & ChartViewModelOutput

final class ChartViewModel: ChartViewModelProtocol {
    
    // MARK: - UseCase
    private let chartUseCase: ChartUseCase
    
    // MARK: - Subject
    private let dailyChartSubject = PassthroughSubject<StudyLog, Never>()
    
    // MARK: - Publihser
    var dailyChartPublisher: AnyPublisher<StudyLog, Never> {
        return dailyChartSubject.eraseToAnyPublisher()
    }
    
    init(chartUseCase: ChartUseCase) {
        self.chartUseCase = chartUseCase
    }
    
    func viewDidLoad() {
        fetchDailyChartLog(at: Date())
    }

    func fetchDailyChartLog(at date: Date) {
        Task {
            let log = try await chartUseCase.fetchDailyChartLog(at: date)
            dailyChartSubject.send(log.studyLog)
        }
    }
}
