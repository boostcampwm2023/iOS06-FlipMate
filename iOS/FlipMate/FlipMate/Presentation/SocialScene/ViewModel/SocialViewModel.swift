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
}

protocol SocialViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func freindAddButtonDidTapped()
}

protocol SocialViewModelOutput {
    var freindsPublisher: AnyPublisher<[Friend], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var updateFriendStatus: AnyPublisher<[UpdateFriend], Never> { get }
    var stopFriendStatus: AnyPublisher<[StopFriend], Never> { get }
}

typealias SocialViewModelProtocol = SocialViewModelInput & SocialViewModelOutput

final class SocialViewModel: SocialViewModelProtocol {
    // MARK: - Subject
    private var freindsSubject = PassthroughSubject<[Friend], Never>()
    private var nicknameSubject = CurrentValueSubject<String, Never>(UserInfoStorage.nickname)
    private var updateFriendSubject = PassthroughSubject<[UpdateFriend], Never>()
    private var stopFriendSubject = PassthroughSubject<[StopFriend], Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let actions: SocialViewModelActions?
    private let socialUseCase: SocialUseCase
    private var timerState: TimerState = .notStarted
    private var friendStatusPollingManager: FriendStatusPollingManageable
    private lazy var timerManager: TimerManager = .init(timeInterval: .seconds(5), handler: fetchFriendStatus)
    
    // MARK: - init
    init(actions: SocialViewModelActions? = nil, socialUseCase: SocialUseCase, friendStatusPollingManager: FriendStatusPollingManageable) {
        self.actions = actions
        self.socialUseCase = socialUseCase
        self.friendStatusPollingManager = friendStatusPollingManager
    }
    
    // MARK: - Output
    var freindsPublisher: AnyPublisher<[Friend], Never> {
        return freindsSubject.eraseToAnyPublisher()
    }
    
    var nicknamePublisher: AnyPublisher<String, Never> {
        return nicknameSubject.eraseToAnyPublisher()
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
    
    func viewDidLoad() {
        getUserProfile()
        getFriendState()
    }
    
    func viewWillAppear() {
        getFriendState()
        FMLogger.friend.debug("친구 상태 폴링 시작")
        timerState = .resumed
        if timerState == .notStarted {
            timerManager.start(startTime: Date())
        } else {
            timerManager.resume(resumeTime: Date())
        }
    }
    
    func viewWillDisappear() {
        FMLogger.friend.debug("친구 상태 폴링 종료")
        timerState = .suspended
        timerManager.suspend()
        friendStatusPollingManager.stopPolling()
    }
}

private extension SocialViewModel {
    func getFriendState() {
        socialUseCase.getMyFriend(date: Date())
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
        socialUseCase.fetchMyFriend(date: Date())
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
    
    func getUserProfile() {
        UserInfoStorage.$nickname
            .sink { [weak self] nickName in
                guard let self = self else { return }
                self.nicknameSubject.send(nickName)
            }
            .store(in: &cancellables)
    }
}
