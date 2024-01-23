//
//  FollowingsViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

struct FollowersViewModelActions {
    let viewDidFinish: () -> Void
}

protocol FollowersViewModelInput {
    func followerButtonTouched()
    func fetchFollowers()
}

protocol FollowersViewModelOutput {
    var followersPublisher: AnyPublisher<[Follower], Never> { get }
}

typealias FollowersViewModelProtocol = FollowersViewModelInput & FollowersViewModelOutput

final class FollowersViewModel: FollowersViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    private var followersSubject = PassthroughSubject<[Follower], Never>()
    private let fetchFollowersUseCase: FetchFollowersUseCase
    private let actions: FollowersViewModelActions?
    
    init(fetchFollowersUseCase: FetchFollowersUseCase, actions: FollowersViewModelActions? = nil) {
        self.fetchFollowersUseCase = fetchFollowersUseCase
        self.actions = actions
    }
    
    var followersPublisher: AnyPublisher<[Follower], Never> {
        return followersSubject.eraseToAnyPublisher()
    }
    
    func followerButtonTouched() {
        
    }
    
    func fetchFollowers() {
        fetchFollowersUseCase.fetchMyFollowers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("팔로워 불러오기 성공")
                case .failure(let error):
                    FMLogger.friend.error("팔로워 불러오기 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] followings in
                guard let self = self else { return }
                self.followersSubject.send(followings)
            }
            .store(in: &cancellables)
    }
}
