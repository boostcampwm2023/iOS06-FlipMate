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
    @State private var selectedCount: Int?
    @State private var selectedSector: Category?
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let studyLogs = viewModel.dailyChartLog.studyLog
        let categorySet = studyLogs.category
        let totalTimes = studyLogs.totalTime
        ScrollView(.vertical) {
            VStack {
                CustomCalenderView(selectedDate: $selectedDate, viewModel: viewModel)
                if #available(iOS 17.0, *) {
                    Chart {
                        ForEach(categorySet, id: \.subject) { category in
                            SectorMark(angle: .value(Constant.time, category.studyTime ?? 0), innerRadius: .ratio(0.65), angularInset: 3.0)
                                .foregroundStyle(by: .value(Constant.category, category.subject))
                                .cornerRadius(10.0)
                                .annotation(position: .overlay) {
                                    if getRatio(time: category.studyTime ?? 0, sum: totalTimes) > 0.05 {
                                        DailyChartView.StrokeText(text: "\(category.studyTime ?? 0)",
                                                                  width: 0.3, color: colorScheme == .dark ? .black : .white)
                                        .font(.headline)
                                    }
                                }
                                .opacity(selectedSector == nil ? 1.0 : (selectedSector == category ? 1.0 : 0.3))
                        }
                    }
                    .chartForegroundStyleScale(domain: categorySet.compactMap({ category in
                        category.subject
                    }), range: getColorArray(categories: categorySet))
                    .frame(height: 400 * (UIScreen.main.bounds.size.height / 844))
                    .chartBackground { _ in
                        if selectedSector == nil {
                            VStack {
                                Text(Constant.totalTime).font(.callout)
                                    .foregroundStyle(.secondary)
                                Text("\(totalTimes.secondsToStringTime())").font(.system(size: 36))}
                            .padding(.bottom, 20)
                        } else {
                            VStack {
                                Text("\(selectedSector?.subject ?? "")").font(.callout)
                                    .foregroundStyle(.primary)
                                Text("\((selectedSector?.studyTime ?? 0).secondsToStringTime())").font(.system(size: 36))}
                            .padding(.bottom, 20)
                        }
                    }
                    .chartAngleSelection(value: $selectedCount)
                    .onChange(of: selectedCount) { _, newValue in
                        if let newValue {
                            selectedSector = findSelectorSector(value: newValue)
                        } else {
                            selectedSector = nil
                        }
                    }
                } else if #available(iOS 16.0, *) {
                    Text(Constant.totalTime).font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(totalTimes.secondsToStringTime())").font(.system(size: 36))
                    
                    Chart {
                        ForEach(categorySet, id: \.subject) { category in
                            BarMark(x: .value(Constant.time, Float(category.studyTime ?? 0) / 60), y: .value(Constant.category, category.subject))
                                .foregroundStyle(by: .value("", category.color))
                        }
                    }
                    .chartLegend(.hidden)
                      .chartForegroundStyleScale(domain: categorySet.compactMap({ category in
                        category.subject
                    }), range: getColorArray(categories: categorySet))
                    .frame(height: CGFloat(60 * categorySet.count) * (UIScreen.main.bounds.size.height / 844))
                    .chartXAxisLabel(Constant.min)
                } else {
                    Text(Constant.message)
                }
            }.padding()
        }
    }
    
    private func getColorArray(categories: [Category]) -> [Color] {
        let colorArray: [Color] = categories.map { category in
            if let uiColor = UIColor(hexString: category.color) {
                return Color(uiColor)
            } else {
                return Color.gray
            }
        }
        return colorArray
    }
    
    private func getRatio(time: Int, sum: Int) -> Float {
        return Float(time) / Float(sum)
    }
    
    private func findSelectorSector(value: Int) -> Category? {
        var accumulatedCount = 0
        
        let category = viewModel.dailyChartLog.studyLog.category.first { category in
            accumulatedCount += category.studyTime ?? 0
            return value <= accumulatedCount
        }
        
        return category
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
    
    struct StrokeText: View {
        let text: String
        let width: CGFloat
        let color: Color
        
        var body: some View {
            ZStack {
                ZStack {
                    Text(text).offset(x: width, y: width)
                    Text(text).offset(x: -width, y: width)
                    Text(text).offset(x: width, y: -width)
                    Text(text).offset(x: -width, y: -width)
                }
                .foregroundColor(color)
                Text(text)
            }
        }
    }
}
