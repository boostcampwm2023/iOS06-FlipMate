//
//  DefaultFollowFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Core
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
