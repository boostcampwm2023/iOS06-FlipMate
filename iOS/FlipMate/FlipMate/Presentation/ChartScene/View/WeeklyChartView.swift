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
        VStack {
            Text("주간 학습 추이").font(.title).padding(.trailing, 180).padding(.bottom, 30)
            if #available(iOS 16.0, *) {
                ScrollView(.vertical) {
                    Chart {
                        ForEach(viewModel.weeklyChartLog.dailyData, id: \.day) { data in
                            BarMark(x: .value("요일", data.day), y: .value("분", Float(data.studyTime) / 60))
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
                }
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }
        .onAppear {
            Task {
                try await viewModel.showWeeklyChart()
            }
        }
    }
}

#Preview {
    WeeklyChartView(viewModel: ChartViewModel(chartUseCase: DefaultChartUseCase(repository: DefaultChartRepository(provider: Provider(urlSession: URLSession.shared)))))
}
