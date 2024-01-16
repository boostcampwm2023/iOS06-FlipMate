//
//  DefaultFetchFollowingsUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

final class DefaultFetchFollowingsUseCase: FetchFollowingsUseCase {
    private let repository: SocialRepository
    
    init(repository: SocialRepository) {
        self.repository = repository
    }
    
    func fetchMyFollowings() -> AnyPublisher<[Follower], NetworkError> {
        return repository.fetchMyFollowings()
    }
}
