//
//  DefaultFriendUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

final class DefaultFollowFriendUseCase: FollowFriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return repository.follow(at: nickname)
    }
}

final class DefaultUnfollowFriendUseCase: UnfollowFriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        return repository.unfollow(at: id)
    }
}

final class DefaultSearchFriendUseCase: SearchFriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError> {
        return repository.search(at: nickname)
    }
}

final class DefaultLoadChartUseCase: LoadChartUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        return repository.loadChart(at: id)
    }
}
