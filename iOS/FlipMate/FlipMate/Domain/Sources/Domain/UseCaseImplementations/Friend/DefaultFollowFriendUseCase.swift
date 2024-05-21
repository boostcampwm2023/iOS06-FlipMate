//
//  DefaultFollowFriendUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public final class DefaultFollowFriendUseCase: FollowFriendUseCase {
    private let repository: FriendRepository
    
    public init(repository: FriendRepository) {
        self.repository = repository
    }
    
    public func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return repository.follow(at: nickname)
    }
}

