//
//  FriendAddViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

struct FriendAddViewModelActions {
    var didCancleFriendAdd: () -> Void
    var didSuccessFriendAdd: () -> Void
}

protocol FriendAddViewModelInput {
    func nicknameDidChange(at nickname: String)
    func didFollowFriend()
    func didSearchFriend()
    func dismissButtonDidTapped()
}

protocol FriendAddViewModelOutput {
    var myNicknamePublihser: AnyPublisher<String, Never> { get }
    var searchFreindPublisher: AnyPublisher<FreindSeacrhItem, Never> { get }
    var searchErrorPublisher: AnyPublisher<Error, Never> { get }
    var nicknameCountPublisher: AnyPublisher<Int, Never> { get }
    var followErrorPublisher: AnyPublisher<Void, Never> { get }
}

typealias FriendAddViewModelProtocol = FriendAddViewModelInput & FriendAddViewModelOutput

final class FriendAddViewModel: FriendAddViewModelProtocol {
    // MARK: - Subject
    private var searchResultSubject = PassthroughSubject<FreindSeacrhItem, Never>()
    private var searchErrorSubject = PassthroughSubject<Error, Never>()
    private var nicknameCountSubject = PassthroughSubject<Int, Never>()
    private var followErrorSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var friendNickname: String = ""
    private let followUseCase: FollowFriendUseCase
    private let searchUseCase: SearchFriendUseCase
    private let actions: FriendAddViewModelActions?
    private let userInfoManger: UserInfoManageable
    
    init(followUseCase: FollowFriendUseCase,
         searchUseCase: SearchFriendUseCase,
         actions: FriendAddViewModelActions? = nil,
         userInfoManager: UserInfoManageable) {
        self.followUseCase = followUseCase
        self.searchUseCase = searchUseCase
        self.actions = actions
        self.userInfoManger = userInfoManager
    }
    
    // MARK: - output
    var searchFreindPublisher: AnyPublisher<FreindSeacrhItem, Never> {
        return searchResultSubject.eraseToAnyPublisher()
    }
    
    var searchErrorPublisher: AnyPublisher<Error, Never> {
        return searchErrorSubject.eraseToAnyPublisher()
    }
    
    var nicknameCountPublisher: AnyPublisher<Int, Never> {
        return nicknameCountSubject.eraseToAnyPublisher()
    }
    
    var myNicknamePublihser: AnyPublisher<String, Never> {
        return userInfoManger.nicknameChangePublisher
    }
    
    var followErrorPublisher: AnyPublisher<Void, Never> {
        return followErrorSubject.eraseToAnyPublisher()
    }

    // MARK: - Input
    func didFollowFriend() {
        followUseCase.follow(at: friendNickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("친구 요청 성공")
                case .failure(let error):
                    guard let self = self else { return }
                    FMLogger.friend.error("친구 요청 에러 발생 \(error)")
                    self.followErrorSubject.send()
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.actions?.didSuccessFriendAdd()
            }
            .store(in: &cancellables)
    }
    
    func didSearchFriend() {
        searchUseCase.search(at: friendNickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    FMLogger.friend.debug("친구 검색 성공")
                case .failure(let error):
                    FMLogger.friend.error("친구 검색 에러 발생 \(error.localizedDescription)")
                    self.searchErrorSubject.send(error)
                }
            } receiveValue: { [weak self] friendSearchResult in
                guard let self = self else { return }
                self.searchResultSubject.send(FreindSeacrhItem(
                    nickname: friendNickname,
                    iamgeURL: friendSearchResult.imageURL,
                    status: friendSearchResult.status)
                )
            }
            .store(in: &cancellables)
    }
    
    func nicknameDidChange(at nickname: String) {
        friendNickname = nickname
        nicknameCountSubject.send(nickname.count)
    }
    
    func dismissButtonDidTapped() {
        actions?.didCancleFriendAdd()
    }
}
