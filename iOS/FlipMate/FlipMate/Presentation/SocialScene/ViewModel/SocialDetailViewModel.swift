//
//  SocialDetailViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation
import Combine

struct SocialDetailViewModelActions {
    var didCancelSocialDetail: () -> Void
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
        friendUseCase.loadChart(at: friend.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("차트 조회 성공")
                case .failure(let error):
                    FMLogger.friend.error("차트 조회 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] chartInfo in
                guard let self = self else { return }
                self.socialChart = chartInfo
                self.handleChartInfo(socialChart)
            }
            .store(in: &cancellables)
    }
    
    func didUnfollowFriend() {
        friendUseCase.unfollow(at: friend.id)
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
    
    func dismissButtonDidTapped() {
        actions?.didCancelSocialDetail()
    }
}

private extension SocialDetailViewModel {
    func handleChartInfo(_ chartInfo: SocialChart) {
        guard chartInfo.myData.count >= 7, chartInfo.friendData.count >= 7 else { return }
        
        let myChartData = generateStudyTimeData(from: chartInfo.myData)
        let friendChartData = generateStudyTimeData(from: chartInfo.friendData)
        
        let newSeries: [Series] = [Series(user: "나", studyTime: myChartData),
                                   Series(user: "친구", studyTime: friendChartData)]
        
        self.userSeries = newSeries
    }
    
    func generateStudyTimeData(from data: [Int]) -> [StudyTime] {
        return (0..<7).map { index in
            StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * Double(6 - index)), studyTime: data[index])
        }
    }
}
