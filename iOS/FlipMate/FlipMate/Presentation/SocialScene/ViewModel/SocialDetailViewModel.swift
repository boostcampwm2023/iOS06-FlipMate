//
//  SocialDetailViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation
import Combine

final class SocialDetailViewModel: ObservableObject {
    @Published var socialChart: SocialChart = .init(myData: [], friendData: [], primaryCategory: nil)
    @Published var userSeries: [Series]
    
    private var cancellables = Set<AnyCancellable>()
    private var friendInfo: FriendInfo
    private var friendUseCase: FriendUseCase
    
    init(friendInfo: FriendInfo, friendUseCase: FriendUseCase) {
        self.friendInfo = friendInfo
        self.friendUseCase = friendUseCase
        self.userSeries = [Series]()
    }

    func viewDidLoad() {
        friendUseCase.getChartInfo(at: friendInfo.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("차트 조회 성공")
                case .failure(let error):
                    FMLogger.timer.error("차트 조회 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] chartInfo in
                guard let self = self, chartInfo.myData.count >= 7, chartInfo.friendData.count >= 7 else { return }
                self.socialChart = chartInfo
                let myChartData: [StudyTime] = [
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 6), studyTime: chartInfo.myData[0]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 5), studyTime: chartInfo.myData[1]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 4), studyTime: chartInfo.myData[2]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 3), studyTime: chartInfo.myData[3]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 2), studyTime: chartInfo.myData[4]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400), studyTime: chartInfo.myData[5]),
                    StudyTime(weekday: Date(), studyTime: chartInfo.myData[6])
                ]
                
                let friendChartData: [StudyTime] = [
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 6), studyTime: chartInfo.friendData[0]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 5), studyTime: chartInfo.friendData[1]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 4), studyTime: chartInfo.friendData[2]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 3), studyTime: chartInfo.friendData[3]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * 2), studyTime: chartInfo.friendData[4]),
                    StudyTime(weekday: Date(timeIntervalSinceNow: -86400), studyTime: chartInfo.friendData[5]),
                    StudyTime(weekday: Date(), studyTime: chartInfo.friendData[6])
                ]
                let newSeries: [Series] = [Series(user: "나", studyLog: myChartData), Series(user: "친구", studyLog: friendChartData)]
                
                self.userSeries = newSeries
            }
            .store(in: &cancellables)
    }
    
    func didUnfollowFriend() {
        friendUseCase.unfollow(at: friendInfo.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("팔로우 취소 성공")
                case .failure(let error):
                    FMLogger.friend.error("팔로우 취소 에러 발생 \(error)")
                }
            } receiveValue: { _ in
                // TODO: - Coordinator로 화면 전환
            }
            .store(in: &cancellables)
    }
}
