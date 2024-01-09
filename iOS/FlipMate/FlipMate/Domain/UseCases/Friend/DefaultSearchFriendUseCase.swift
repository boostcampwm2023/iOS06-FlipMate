//
//  DefaultSearchFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

final class DefaultSearchFriendUseCase: SearchFriendUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError> {
        return repository.search(at: nickname)
    }
}
