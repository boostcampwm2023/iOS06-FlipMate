//
//  FollowFriendUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol FollowFriendUseCase {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError>
}
