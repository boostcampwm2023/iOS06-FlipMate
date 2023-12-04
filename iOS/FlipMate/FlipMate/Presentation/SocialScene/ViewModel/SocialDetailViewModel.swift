//
//  SocialDetailViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation
import Combine

struct SocialDetailViewModelActions {
    var didFinishUnfollow: () -> Void
}

final class SocialDetailViewModel: ObservableObject {
    @Published var socialChart: SocialChart = .init(myData: [], friendData: [], primaryCategory: nil)
    @Published var userSeries: [Series] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let friend: Friend
    private let friendUseCase: FriendUseCase
    private let actions: SocialDetailViewModelActions?
    
    // MARK: - Subject
    private lazy var friendSubject = CurrentValueSubject<Friend, Never>(friend)
    
    // MARK: - Publisher
    var friendPublisher: AnyPublisher<Friend, Never> {
        return friendSubject.eraseToAnyPublisher()
    }
    
    init(friend: Friend, friendUseCase: FriendUseCase, actions: SocialDetailViewModelActions? = nil) {
        self.friend = friend
        self.friendUseCase = friendUseCase
        self.actions = actions
    }
    
    func viewDidLoad() {
        friendUseCase.loadChart(at: friend.id ?? 0)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("차트 조회 성공")
                case .failure(let error):
                    FMLogger.friend.error("차트 조회 실패 \(error.localizedDescription)")
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
                
                let newSeries: [Series] = [Series(user: "나", studyTime: myChartData), Series(user: "친구", studyTime: friendChartData)]
                
                self.userSeries = newSeries
            }
            .store(in: &cancellables)
    }
    
    func didUnfollowFriend() {
        friendUseCase.unfollow(at: friend.id ?? 0)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("팔로우 취소 성공")
                case .failure(let error):
                    FMLogger.friend.error("팔로우 취소 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.actions?.didFinishUnfollow()
            }
            .store(in: &cancellables)
    }
}
