//
//  FetchFollowersUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

protocol FetchFollowersUseCase {
    func fetchMyFollowers() -> AnyPublisher<[Follower], NetworkError>
}
