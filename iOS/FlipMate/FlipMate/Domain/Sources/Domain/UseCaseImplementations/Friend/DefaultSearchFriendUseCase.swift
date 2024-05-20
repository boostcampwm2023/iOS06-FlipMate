//
//  DefaultSearchFriendUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public final class DefaultSearchFriendUseCase: SearchFriendUseCase {
    private let repository: FriendRepository
    
    public init(repository: FriendRepository) {
        self.repository = repository
    }
    
    public func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError> {
        return repository.search(at: nickname)
    }
}
