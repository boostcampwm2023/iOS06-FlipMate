//
//  DefaultFetchFollowersUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

final class DefaultFetchFollowersUseCase: FetchFollowersUseCase {
    private let repository: SocialRepository
    
    init(repository: SocialRepository) {
        self.repository = repository
    }
    
    func fetchMyFollowers() -> AnyPublisher<[Follower], NetworkError> {
        return repository.fetchMyFollowings()
    }
}
