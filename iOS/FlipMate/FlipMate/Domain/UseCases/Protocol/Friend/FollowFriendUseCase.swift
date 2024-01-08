//
//  FollowFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

protocol FollowFriendUseCase {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError>
}
