//
//  DefaultFriendUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

final class DefaultFriendUseCase: FriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return repository.follow(at: nickname)
            .map { response -> String in
                return response.message
            }
            .eraseToAnyPublisher()
    }
    
    func search(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return repository.search(at: nickname)
            .map { response -> String in
                return response.profileImageURL
            }
            .eraseToAnyPublisher()
    }
}
