//
//  SocialChartView.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import SwiftUI
import Charts
import Combine

struct SocialChartView: View {
    @ObservedObject var viewModel: SocialDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SocialDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if #available(iOS 16.0, *) {
                    Chart(viewModel.userSeries) { series in
                        ForEach(series.studyTime) { time in
                            PointMark(x: .value(Constant.date, time.weekday, unit: .day), y: .value(Constant.studyTime, Float(time.studyTime) / 60))
                            LineMark(x: .value(Constant.date, time.weekday, unit: .day), y: .value(Constant.studyTime, Float(time.studyTime) / 60))
                        }
                        .foregroundStyle(by: .value(Constant.user, series.user))
                    }
                    .frame(height: 360)
                    .chartYAxisLabel(Constant.min)
                } else {
                    Text(Constant.message)
                }
            }.padding()
        }
    }
}

private extension SocialChartView {
    enum Constant {
        static let message = NSLocalizedString("MessageOfiOS16", comment: "")
        static let date = NSLocalizedString("date", comment: "")
        static let user = NSLocalizedString("user", comment: "")
        static let studyTime = NSLocalizedString("studyTime", comment: "")
        static let min = NSLocalizedString("min", comment: "")
    }
}
