//
//  DailyChartView.swift
//  FlipMate
//
//  Created by 신민규 on 12/4/23.
//

import SwiftUI
import Charts

struct DailyChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    @State var date = Date()
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            CustomCalenderView()
            if #available(iOS 17.0, *) {
                Chart {
                    ForEach(viewModel.dailyChartLog.studyLog.category, id: \.subject) { category in
                        SectorMark(angle: .value("시간", category.studyTime ?? 0), innerRadius: .ratio(0.65), angularInset: 3.0)
                            .foregroundStyle(by: .value("카테고리", category.subject))
                            .cornerRadius(10.0)
                            .annotation(position: .overlay) {
                                Text("\(category.studyTime ?? 0)")
                                    .font(.headline)
                            }
                    }
                }
                .frame(height: 400)
                .chartBackground { _ in
                    VStack {
                        Text("총 학습 시간").font(.callout)
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.dailyChartLog.studyLog.totalTime.secondsToStringTime())").font(.system(size: 36))}
                    .padding(.bottom, 20)
                }
            } else if #available(iOS 16.0, *) {
                    Text("총 학습 시간").font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.dailyChartLog.studyLog.totalTime.secondsToStringTime())").font(.system(size: 36))
        
                    Chart {
                        ForEach(viewModel.dailyChartLog.studyLog.category, id: \.subject) { category in
                            BarMark(x: .value("시간", Float(category.studyTime ?? 0) / 60), y: .value("카테고리", category.subject))
                                .foregroundStyle(by: .value("", category.color))
                        }
                    }
                    .chartLegend(.hidden)
                    .frame(height: 400)
                    .chartXAxisLabel("분 (m)")
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }.padding()
    }
}

#Preview {
    DailyChartView(viewModel: ChartViewModel(chartUseCase: DefaultChartUseCase(repository: DefaultChartRepository(provider: Provider(urlSession: URLSession.shared))), actions: ChartViewModelActions()))
}
