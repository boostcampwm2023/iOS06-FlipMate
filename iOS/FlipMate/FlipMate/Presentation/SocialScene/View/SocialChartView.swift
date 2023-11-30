//
//  SocialChartView.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import SwiftUI
import Charts

struct SocialChartView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Chart(viewModel.mockSeriesData) { series in
                    ForEach(series.studyLog) { time in
                        PointMark(x: .value("날짜", time.weekday, unit: .day),
                                 y: .value("학습 시간", time.studyTime))
                        LineMark(x: .value("날짜", time.weekday, unit: .day),
                                 y: .value("학습 시간", time.studyTime))
                    }.foregroundStyle(by: .value("사용자", series.user))}
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }.padding()
    }
}

extension SocialChartView {
    class ViewModel: ObservableObject {
        @Published private var socialChart: SocialChart = .init(myData: [], friendData: [], primaryCategory: nil)
        
        lazy var mockMyData: [StudyTime] = {
            guard socialChart.myData.count >= 7 else {
                return Array(repeating: StudyTime(weekday: Date(), studyTime: 0), count: 7)
            }
            
            return [
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 6), studyTime: socialChart.myData[0]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 5), studyTime: socialChart.myData[1]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 4), studyTime: socialChart.myData[2]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 3), studyTime: socialChart.myData[3]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 2), studyTime: socialChart.myData[4]),
                .init(weekday: Date(timeIntervalSinceNow: -86400), studyTime: socialChart.myData[5]),
                .init(weekday: Date(), studyTime: socialChart.myData[6])
            ]
        }()
        
        lazy var mockFriendData: [StudyTime] = {
            guard socialChart.friendData.count >= 7 else {
                return Array(repeating: StudyTime(weekday: Date(), studyTime: 0), count: 7)
            }
            return [
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 6), studyTime: socialChart.friendData[0]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 5), studyTime: socialChart.friendData[1]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 4), studyTime: socialChart.friendData[2]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 3), studyTime: socialChart.friendData[3]),
                .init(weekday: Date(timeIntervalSinceNow: -86400 * 2), studyTime: socialChart.friendData[4]),
                .init(weekday: Date(timeIntervalSinceNow: -86400), studyTime: socialChart.friendData[5]),
                .init(weekday: Date(), studyTime: socialChart.friendData[6])
            ]
        }()
        
        lazy var mockSeriesData: [Series] = [
            .init(user: "나", studyLog: mockMyData),
            .init(user: "친구", studyLog: mockFriendData)
        ]
    }
}

// MARK: - Temp Mock Data
struct StudyTime: Identifiable {
    var id: UUID = UUID()
    
    let weekday: Date
    let studyTime: Int
}

struct Series: Identifiable {
    var id: UUID = UUID()
    
    let user: String
    let studyLog: [StudyTime]
}

#Preview {
    SocialChartView(viewModel: SocialChartView.ViewModel())
}
