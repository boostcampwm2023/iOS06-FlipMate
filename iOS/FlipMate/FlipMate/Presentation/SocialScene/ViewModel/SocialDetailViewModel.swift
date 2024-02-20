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

protocol SocialDetailViewModelInput {
    func viewDidLoad()
    func didUnfollowFriend()
    func dismissButtonDidTapped()
}

protocol SocialDetailViewModelOutput {
    var friendPublisher: AnyPublisher<Friend, Never> { get }
    var seriesPublusher: AnyPublisher<[Series], Never> { get }
}

typealias SocialDetailViewModelProtocol = SocialDetailViewModelInput & SocialDetailViewModelOutput

final class SocialDetailViewModel: SocialDetailViewModelProtocol {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let friend: Friend
    private let actions: SocialDetailViewModelActions?
    
    // MARK: - UseCase
    private let loadChartUseCase: LoadChartUseCase
    private let unfollowUseCase: UnfollowFriendUseCase
    
    // MARK: - Subject
    private lazy var friendSubject = CurrentValueSubject<Friend, Never>(friend)
    private let seriesSubject = PassthroughSubject<[Series], Never>()
    
    // MARK: - Publisher
    var friendPublisher: AnyPublisher<Friend, Never> {
        return friendSubject.eraseToAnyPublisher()
    }
    
    var seriesPublusher: AnyPublisher<[Series], Never> {
        return seriesSubject.eraseToAnyPublisher()
    }
    
    init(friend: Friend,
         loadChartUseCase: LoadChartUseCase,
         unfollowUseCase: UnfollowFriendUseCase,
         actions: SocialDetailViewModelActions? = nil) {
        self.friend = friend
        self.loadChartUseCase = loadChartUseCase
        self.unfollowUseCase = unfollowUseCase
        self.actions = actions
    }
    
    func viewDidLoad() {
        loadChartUseCase.loadChart(at: friend.id)
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
                self.handleChartInfo(chartInfo)
            }
            .store(in: &cancellables)
    }
    
    func didUnfollowFriend() {
        unfollowUseCase.unfollow(at: friend.id)
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
        
        let newSeries: [Series] = [Series(user: NSLocalizedString("me", comment: ""), studyTime: myChartData),
                                   Series(user: NSLocalizedString("friend", comment: ""), studyTime: friendChartData)]
        
        seriesSubject.send(newSeries)
    }
    
    func generateStudyTimeData(from data: [Int]) -> [StudyTime] {
        return (0..<7).map { index in
            StudyTime(weekday: Date(timeIntervalSinceNow: -86400 * Double(6 - index)), studyTime: data[index])
        }
    }
}
