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
    @State private var selectedDate = Date()
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            CustomCalenderView(selectedDate: $selectedDate, viewModel: viewModel)
            ScrollView(.vertical) {
                if #available(iOS 17.0, *) {
                    Chart {
                        ForEach(viewModel.dailyChartLog.studyLog.category, id: \.subject) { category in
                            SectorMark(angle: .value(Constant.time, category.studyTime ?? 0), innerRadius: .ratio(0.65), angularInset: 3.0)
                                .foregroundStyle(by: .value(Constant.category, category.subject))
                                .cornerRadius(10.0)
                                .annotation(position: .overlay) {
                                    if category.studyTime != 0 {
                                        Text("\(category.studyTime ?? 0)")
                                            .font(.headline)
                                    }
                                }
                        }
                    }
                    .chartForegroundStyleScale(domain: viewModel.dailyChartLog.studyLog.category.compactMap({ category in
                        category.subject
                    }), range: getColorArray(categories: viewModel.dailyChartLog.studyLog.category))
                    .frame(height: 400 * (UIScreen.main.bounds.size.height / 844))
                    .chartBackground { _ in
                        VStack {
                            Text(Constant.totalTime).font(.callout)
                                .foregroundStyle(.secondary)
                            Text("\(viewModel.dailyChartLog.studyLog.totalTime.secondsToStringTime())").font(.system(size: 36))}
                        .padding(.bottom, 20)
                    }
                } else if #available(iOS 16.0, *) {
                    Text(Constant.totalTime).font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.dailyChartLog.studyLog.totalTime.secondsToStringTime())").font(.system(size: 36))
                    
                    Chart {
                        ForEach(viewModel.dailyChartLog.studyLog.category, id: \.subject) { category in
                            BarMark(x: .value(Constant.time, Float(category.studyTime ?? 0) / 60), y: .value(Constant.category, category.subject))
                                .foregroundStyle(by: .value("", category.color))
                        }
                    }
                    .chartLegend(.hidden)
                    .frame(height: 360 * (UIScreen.main.bounds.size.height / 844))
                    .chartXAxisLabel(Constant.min)
                } else {
                    Text(Constant.message)
                }
            }
        }.padding()
    }
    
    func getColorArray(categories: [Category]) -> [Color] {
        let colorArray: [Color] = categories.map { category in
            if let uiColor = UIColor(hexString: category.color) {
                return Color(uiColor)
            } else {
                return Color.gray
            }
        }
        return colorArray
    }
}

private extension DailyChartView {
    enum Constant {
        static let message = NSLocalizedString("MessageOfiOS16", comment: "")
        static let time = NSLocalizedString("time", comment: "")
        static let totalTime = NSLocalizedString("totalTime", comment: "")
        static let category = NSLocalizedString("category", comment: "")
        static let min = NSLocalizedString("date", comment: "")
    }
}
