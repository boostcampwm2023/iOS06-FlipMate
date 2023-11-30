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
    }
    
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        return repository.unfollow(at: id)
    }
    
    func search(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return repository.search(at: nickname)
    }
    
    func getChartInfo(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        return repository.getChartInfo(at: id)
    }
}
