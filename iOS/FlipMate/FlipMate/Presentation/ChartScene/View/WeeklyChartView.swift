//
//  DailyChartView.swift
//  FlipMate
//
//  Created by 신민규 on 12/4/23.
//

import SwiftUI
import Charts

struct WeeklyChartView: View {
    @State var date = Date()
    var totalTime: Int = 25230
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Chart {
                    ForEach(weeklyData, id: \.subject) { category in
                        SectorMark(angle: .value("시간", category.studyTime ?? 0), innerRadius: .ratio(0.65), angularInset: 3.0)
                            .foregroundStyle(by: .value("카테고리", category.subject))
                            .cornerRadius(10.0)
                            .annotation(position: .overlay) {
                                Text("\(category.studyTime ?? 0)")
                                    .font(.headline)
                                    .foregroundStyle(.darkBlue)
                            }
                    }
                }
                .frame(height: 500)
                .chartBackground { _ in
                    VStack {
                        Text("오늘의 학습 시간").font(.callout)
                            .foregroundStyle(.secondary)
                        Text("\(totalTime)s").font(.system(size: 36))}
                }
            } else if #available(iOS 16.0, *) {
                Chart {
                    ForEach(weeklyData, id: \.subject) { category in
                        BarMark(x: .value("시간", Float(category.studyTime ?? 0) / 60), y: .value("카테고리", category.subject))
                            .foregroundStyle(by: .value("", category.color))
                        }
                    }
                .chartLegend(.hidden)
                .frame(height: 300)
                .chartXAxisLabel("분 (m)")
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }.padding()
    }
}

let weeklyData: [Category] = [.init(id: 1, color: "1591FFFF", subject: "요리", studyTime: 1241),
                        .init(id: 2, color: "295AA5FF", subject: "김장", studyTime: 675),
                        .init(id: 3, color: "000000FF", subject: "제빵", studyTime: 51),
                        .init(id: 4, color: "66FF00FF", subject: "도둑질", studyTime: 964),
                        .init(id: 5, color: "FF000000", subject: "게임", studyTime: 549),
                        .init(id: 6, color: "0000BBEE", subject: "티타임", studyTime: 440),
                        .init(id: 7, color: "638109FF", subject: "공부", studyTime: 40)]

#Preview {
    WeeklyChartView()
}
