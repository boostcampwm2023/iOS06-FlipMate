//
//  DailyChartView.swift
//  FlipMate
//
//  Created by 신민규 on 12/4/23.
//

import SwiftUI
import Charts

struct WeeklyChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
            Text(Constant.weeklyLearingChart).font(.title).padding(.trailing, 180).padding(.bottom, 30)
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(viewModel.weeklyChartLog.dailyData, id: \.day) { data in
                            BarMark(x: .value(Constant.day, data.day), y: .value(Constant.min, Float(data.studyTime) / 60))
                                .foregroundStyle(by: .value("", data.day))
                                .annotation {
                                    Text("\(data.studyTime)")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                    .chartYAxis(.hidden)
                    .chartLegend(.hidden)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .frame(height: 300 * (UIScreen.main.bounds.size.height / 844))
                } else {
                    Text(Constant.message)
                }
            }
            .onAppear {
                Task {
                    try await viewModel.showWeeklyChart()
                }
            }
        }
    }
}

private extension WeeklyChartView {
    enum Constant {
        static let message = NSLocalizedString("MessageOfiOS16", comment: "")
        static let day = NSLocalizedString("day", comment: "")
        static let weeklyLearingChart = NSLocalizedString("weeklyLearingChart", comment: "")
        static let min = NSLocalizedString("min", comment: "")
    }
}

#Preview {
    WeeklyChartView(
        viewModel:
            ChartViewModel(
                fetchDailyChartUseCase: DefaultFetchDailyChartUseCase(
                    repository: DefaultChartRepository(
                        provider: Provider(
                            urlSession: URLSession.shared,
                            signOutManager: SignOutManager(userInfoManager: UserInfoManager(),
                                                           keychainManager: KeychainManager()),
                            keychainManager: KeychainManager()))),
                fetchWeeklyChartUseCase: DefaultFetchWeeklyChartUseCase(
                    repository: DefaultChartRepository(
                        provider: Provider(
                            urlSession: URLSession.shared,
                            signOutManager: SignOutManager(userInfoManager: UserInfoManager(),
                                                           keychainManager: KeychainManager()),
                            keychainManager: KeychainManager()))),
                actions: ChartViewModelActions()))
}
