//
//  DefaultUnfollowFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

final class DefaultUnfollowFriendUseCase: UnfollowFriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        return repository.unfollow(at: id)
    }
}
