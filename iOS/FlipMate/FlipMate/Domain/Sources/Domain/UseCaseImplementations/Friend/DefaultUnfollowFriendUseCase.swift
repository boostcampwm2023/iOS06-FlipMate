//
//  DefaultUnfollowFriendUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public final class DefaultUnfollowFriendUseCase: UnfollowFriendUseCase {
    private let repository: FriendRepository
    
    public init(repository: FriendRepository) {
        self.repository = repository
    }
    
    public func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        return repository.unfollow(at: id)
    }
}
