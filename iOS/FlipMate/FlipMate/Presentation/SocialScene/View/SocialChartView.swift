//
//  SocialChartView.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import SwiftUI
import Charts

struct SocialChartView: View {
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Chart(mockSeriesData) { series in
                    ForEach(series.studyLog) { time in
                        LineMark(x: .value("날짜", time.weekday, unit: .day),
                                 y: .value("학습 시간", time.studyTime))
                    }.foregroundStyle(by: .value("사용자", series.user))}
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }.padding()
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

let mockSeriesData: [Series] = [
    .init(user: "나", studyLog: mockMyData),
    .init(user: "친구", studyLog: mockFriendData)
]

let mockMyData: [StudyTime] = [
    .init(weekday: "2023-11-20".stringToDate()!, studyTime: 234),
    .init(weekday: "2023-11-21".stringToDate()!, studyTime: 123),
    .init(weekday: "2023-11-22".stringToDate()!, studyTime: 0),
    .init(weekday: "2023-11-23".stringToDate()!, studyTime: 399),
    .init(weekday: "2023-11-24".stringToDate()!, studyTime: 184),
    .init(weekday: "2023-11-25".stringToDate()!, studyTime: 92),
    .init(weekday: "2023-11-26".stringToDate()!, studyTime: 321)
]

let mockFriendData: [StudyTime] = [
    .init(weekday: "2023-11-20".stringToDate()!, studyTime: 164),
    .init(weekday: "2023-11-21".stringToDate()!, studyTime: 121),
    .init(weekday: "2023-11-22".stringToDate()!, studyTime: 125),
    .init(weekday: "2023-11-23".stringToDate()!, studyTime: 144),
    .init(weekday: "2023-11-24".stringToDate()!, studyTime: 152),
    .init(weekday: "2023-11-25".stringToDate()!, studyTime: 133),
    .init(weekday: "2023-11-26".stringToDate()!, studyTime: 184)
]

#Preview {
    SocialChartView()
}
