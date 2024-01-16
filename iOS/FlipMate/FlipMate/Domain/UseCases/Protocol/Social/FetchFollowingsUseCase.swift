//
//  FetchFollowingsUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

protocol FetchFollowingsUseCase {
    func fetchMyFollowings() -> AnyPublisher<[Follower], NetworkError>
}
