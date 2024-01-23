//
//  FollowingsViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

struct FollowingsViewModelActions {
    let viewDidFinish: () -> Void
}

protocol FollowingsViewModelInput {
    func fetchFollowings()
    func followingButtonTouched()
}

protocol FollowingsViewModelOutput {
    var followingsPublisher: AnyPublisher<[Follower], Never> { get }
}

typealias FollowingsViewModelProtocol = FollowingsViewModelInput & FollowingsViewModelOutput

final class FollowingsViewModel: FollowingsViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    private var followingsSubject = PassthroughSubject<[Follower], Never>()
    private let fetchFollowingsUseCase: FetchFollowingsUseCase
    private let actions: FollowingsViewModelActions?
    
    init(fetchFollowingsUseCase: FetchFollowingsUseCase, actions: FollowingsViewModelActions? = nil) {
        self.fetchFollowingsUseCase = fetchFollowingsUseCase
        self.actions = actions
    }
    
    var followingsPublisher: AnyPublisher<[Follower], Never> {
        return followingsSubject.eraseToAnyPublisher()
    }
    
    func followingButtonTouched() {
        
    }
    
    func fetchFollowings() {
        fetchFollowingsUseCase.fetchMyFollowings()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.log("팔로잉 불러오기 성공")
                case .failure(let error):
                    FMLogger.friend.error("팔로잉 불러오기 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] followings in
                guard let self = self else { return }
                self.followingsSubject.send(followings)
            }
            .store(in: &cancellables)

    }
}
