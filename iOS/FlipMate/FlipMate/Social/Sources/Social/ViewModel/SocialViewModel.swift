//
//  SocialViewModel.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Foundation
import Combine

import Domain
import Core

public struct SocialViewModelActions {
    var showFriendAddViewController: () -> Void
    var showSocialDetailViewController: (Friend) -> Void
    var showMyPageViewController: () -> Void
    
    public init(showFriendAddViewController: @escaping () -> Void, showSocialDetailViewController: @escaping (Friend) -> Void, showMyPageViewController: @escaping () -> Void) {
        self.showFriendAddViewController = showFriendAddViewController
        self.showSocialDetailViewController = showSocialDetailViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public protocol SocialViewModelInput {
    func viewWillAppear()
    func viewDidDisappear()
    func freindAddButtonDidTapped()
    func friendCellDidTapped(friend: Friend)
    func didRefresh()
    func myPageButtonTapped()
}

public protocol SocialViewModelOutput {
    var freindsPublisher: AnyPublisher<[Friend], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var profileImagePublisher: AnyPublisher<String?, Never> { get }
    var totalTimePublisher: AnyPublisher<Int, Never> { get }
    var updateFriendStatus: AnyPublisher<[UpdateFriend], Never> { get }
    var stopFriendStatus: AnyPublisher<[StopFriend], Never> { get }
}

public typealias SocialViewModelProtocol = SocialViewModelInput & SocialViewModelOutput

public final class SocialViewModel: SocialViewModelProtocol {
    // MARK: - Subject
    private var freindsSubject = PassthroughSubject<[Friend], Never>()
    private var updateFriendSubject = PassthroughSubject<[UpdateFriend], Never>()
    private var stopFriendSubject = PassthroughSubject<[StopFriend], Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let actions: SocialViewModelActions?
    private let getFriendsUseCase: GetFriendsUseCase
    private let fetchFriendsUseCase: FetchFriendsUseCase
    
    // MARK: - Managers
    private var friendStatusPollingManager: FriendStatusPollingManageable
    private let timerManager: TimerManageable
    private let userInfoManager: UserInfoManageable
    
    // MARK: - init
    public init(actions: SocialViewModelActions? = nil,
         getFriendsUseCase: GetFriendsUseCase,
         fetchFriendsUseCase: FetchFriendsUseCase,
         friendStatusPollingManager: FriendStatusPollingManageable,
         userInfoManager: UserInfoManageable,
         timerManager: TimerManageable) {
        self.actions = actions
        self.getFriendsUseCase = getFriendsUseCase
        self.fetchFriendsUseCase = fetchFriendsUseCase
        self.friendStatusPollingManager = friendStatusPollingManager
        self.userInfoManager = userInfoManager
        self.timerManager = timerManager
    }
    
    // MARK: - Output
    public var freindsPublisher: AnyPublisher<[Friend], Never> {
        return freindsSubject.eraseToAnyPublisher()
    }
    
    public var nicknamePublisher: AnyPublisher<String, Never> {
        return userInfoManager.nicknameChangePublisher
    }
    
    public var profileImagePublisher: AnyPublisher<String?, Never> {
        return userInfoManager.profileImageChangePublihser
    }
    
    public var totalTimePublisher: AnyPublisher<Int, Never> {
        return userInfoManager.totalTimeChangePublihser
    }
    
    public var updateFriendStatus: AnyPublisher<[UpdateFriend], Never> {
        return friendStatusPollingManager.updateLearningPublihser.eraseToAnyPublisher()
    }
    
    public var stopFriendStatus: AnyPublisher<[StopFriend], Never> {
        return friendStatusPollingManager.updateStopFriendsPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    public func freindAddButtonDidTapped() {
        actions?.showFriendAddViewController()
    }
    
    public func friendCellDidTapped(friend: Friend) {
        actions?.showSocialDetailViewController(friend)
    }
    
    public func viewWillAppear() {
        getFriendState()
        FMLogger.friend.debug("친구 상태 폴링 시작")
        timerManager.start(completion: fetchFriendStatus)
    }
    
    public func viewDidDisappear() {
        FMLogger.friend.debug("친구 상태 폴링 종료")
        friendStatusPollingManager.stopPolling()
        timerManager.cancel()
    }
    
    public func myPageButtonTapped() {
        actions?.showMyPageViewController()
    }
    
    public func didRefresh() {
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
}
