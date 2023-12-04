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
        VStack {
            if #available(iOS 16.0, *) {
                Chart(viewModel.userSeries) { series in
                    ForEach(series.studyTime) { time in
                        PointMark(x: .value("날짜", time.weekday, unit: .day), y: .value("학습 시간", time.studyTime))
                        LineMark(x: .value("날짜", time.weekday, unit: .day), y: .value("학습 시간", time.studyTime))
                    }
                    .foregroundStyle(by: .value("사용자", series.user))
                }
            } else {
                Text("iOS 16.0 이상 버전부터 차트 기능 사용 가능")
            }
        }.padding()
    }
}

#Preview {
    SocialChartView(viewModel: SocialDetailViewModel(friendUseCase: DefaultFriendUseCase(repository: DefaultFriendRepository(provider: Provider(urlSession: URLSession.shared)))))
}
