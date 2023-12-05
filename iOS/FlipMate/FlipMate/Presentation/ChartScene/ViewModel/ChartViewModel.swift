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
    @Published var dailyChartLog: ChartLog = .init(studyLog: StudyLog(totalTime: 0, category: []), percentage: 0)
    
    private var cancellables = Set<AnyCancellable>()
    private let chartUseCase: ChartUseCase
    private let actions: ChartViewModelActions?
    
    init(chartUseCase: ChartUseCase, actions: ChartViewModelActions? = nil) {
        self.chartUseCase = chartUseCase
        self.actions = actions
    }
    
    func selectedDateDidChange(newDate: Date) {
        FMLogger.chart.log("\(newDate)로 날짜 바뀌었네?")
    }
}
