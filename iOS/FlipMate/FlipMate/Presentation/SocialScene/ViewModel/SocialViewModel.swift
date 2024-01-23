//
//  SocialViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

struct SocialViewModelActions {
    var showFriendAddViewController: () -> Void
    var showSocialDetailViewController: (Friend) -> Void
    var showMyPageViewController: () -> Void
    var showFollowingsViewController: () -> Void
    var showFollowersViewController: () -> Void
}

protocol SocialViewModelInput {
    func viewWillAppear()
    func viewDidDisappear()
    func freindAddButtonDidTapped()
    func friendCellDidTapped(friend: Friend)
    func didRefresh()
    func myPageButtonTapped()
    func followingsLabelTapped()
    func followersLabelTapped()
}

protocol SocialViewModelOutput {
    var freindsPublisher: AnyPublisher<[Friend], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var followersNumberPublisher: AnyPublisher<Int, Never> { get }
    var profileImagePublisher: AnyPublisher<String?, Never> { get }
    var totalTimePublisher: AnyPublisher<Int, Never> { get }
    var updateFriendStatus: AnyPublisher<[UpdateFriend], Never> { get }
    var stopFriendStatus: AnyPublisher<[StopFriend], Never> { get }
}

typealias SocialViewModelProtocol = SocialViewModelInput & SocialViewModelOutput

final class SocialViewModel: SocialViewModelProtocol {
    // MARK: - Subject
    private var freindsSubject = PassthroughSubject<[Friend], Never>()
    private var updateFriendSubject = PassthroughSubject<[UpdateFriend], Never>()
    private var stopFriendSubject = PassthroughSubject<[StopFriend], Never>()
    private var followersNumberSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let actions: SocialViewModelActions?
    private let getFriendsUseCase: GetFriendsUseCase
    private let fetchFriendsUseCase: FetchFriendsUseCase
    private let fetchFollowersUseCase: FetchFollowersUseCase
    
    // MARK: - Managers
    private var friendStatusPollingManager: FriendStatusPollingManageable
    private let timerManager: TimerManagerProtocol
    private let userInfoManager: UserInfoManagerProtocol
    
    // MARK: - init
    init(actions: SocialViewModelActions? = nil, 
         getFriendsUseCase: GetFriendsUseCase,
         fetchFriendsUseCase: FetchFriendsUseCase,
         fetchFollowersUseCase: FetchFollowersUseCase,
         friendStatusPollingManager: FriendStatusPollingManageable,
         userInfoManager: UserInfoManagerProtocol,
         timerManager: TimerManagerProtocol) {
        self.actions = actions
        self.getFriendsUseCase = getFriendsUseCase
        self.fetchFriendsUseCase = fetchFriendsUseCase
        self.fetchFollowersUseCase = fetchFollowersUseCase
        self.friendStatusPollingManager = friendStatusPollingManager
        self.userInfoManager = userInfoManager
        self.timerManager = timerManager
    }
    
    // MARK: - Output
    var freindsPublisher: AnyPublisher<[Friend], Never> {
        return freindsSubject.eraseToAnyPublisher()
    }
    
    var nicknamePublisher: AnyPublisher<String, Never> {
        return userInfoManager.nicknameChangePublisher
    }
    
    var followersNumberPublisher: AnyPublisher<Int, Never> {
        return followersNumberSubject.eraseToAnyPublisher()
    }
    
    var profileImagePublisher: AnyPublisher<String?, Never> {
        return userInfoManager.profileImageChangePublihser
    }
    
    var totalTimePublisher: AnyPublisher<Int, Never> {
        return userInfoManager.totalTimeChangePublihser
    }
    
    var updateFriendStatus: AnyPublisher<[UpdateFriend], Never> {
        return friendStatusPollingManager.updateLearningPublihser.eraseToAnyPublisher()
    }
    
    var stopFriendStatus: AnyPublisher<[StopFriend], Never> {
        return friendStatusPollingManager.updateStopFriendsPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    func freindAddButtonDidTapped() {
        actions?.showFriendAddViewController()
    }
    
    func friendCellDidTapped(friend: Friend) {
        actions?.showSocialDetailViewController(friend)
    }
    
    func viewWillAppear() {
        getFriendState()
        fetchFollowers()
        FMLogger.friend.debug("친구 상태 폴링 시작")
        timerManager.start(completion: fetchFriendStatus)
    }
    
    func viewDidDisappear() {
        FMLogger.friend.debug("친구 상태 폴링 종료")
        friendStatusPollingManager.stopPolling()
        timerManager.cancel()
    }
    
    func myPageButtonTapped() {
        actions?.showMyPageViewController()
    }
    
    func followingsLabelTapped() {
        actions?.showFollowingsViewController()
    }
    
    func followersLabelTapped() {
        actions?.showFollowersViewController()
    }
    
    func didRefresh() {
        getFriendState()
    }
}

private extension SocialViewModel {
    func getFriendState() {
        getFriendsUseCase.getMyFriend(date: Date())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("친구 받아오기 성공")
                case .failure(let error):
                    FMLogger.friend.error("친구 받아오기 에러 발생 \(error)")
                }
            } receiveValue: { [weak self] freinds in
                guard let self = self else { return }
                self.freindsSubject.send(freinds)
                let preFriendStatusArray = freinds.map { FriendStatus(id: $0.id, totalTime: $0.totalTime, startedTime: $0.startedTime)}
                self.friendStatusPollingManager.update(preFriendStatusArray: preFriendStatusArray)
                self.friendStatusPollingManager.updateLearningFriendsBeforeLearning(
                    friendsStatus: freinds.map {
                        FriendStatus(
                            id: $0.id,
                            totalTime: $0.totalTime,
                            startedTime: $0.startedTime)
                    }
                )
            }
            .store(in: &cancellables)
    }
    
    func fetchFriendStatus() {
        fetchFriendsUseCase.fetchMyFriend(date: Date())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("친구 상태 업데이트 성공")
                case .failure(let error):
                    FMLogger.friend.error("친구 상태 엡데이트 에러 발생 \(error)")
                }
            } receiveValue: { [weak self] friendStatus in
                guard let self = self else { return }
                self.friendStatusPollingManager.startPolling(friendsStatus: friendStatus)
                self.friendStatusPollingManager.update(preFriendStatusArray: friendStatus)
            }
            .store(in: &cancellables)
    }
    
    func fetchFollowers() {
        fetchFollowersUseCase.fetchMyFollowers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("팔로워 불러오기 성공")
                case .failure(let error):
                    FMLogger.friend.debug("팔로워 불러오기 실패 \(error)")
                }
            } receiveValue: { [weak self] followers in
                guard let self = self else { return }
                self.followersNumberSubject.send(followers.count)
            }
            .store(in: &cancellables)
    }
}
