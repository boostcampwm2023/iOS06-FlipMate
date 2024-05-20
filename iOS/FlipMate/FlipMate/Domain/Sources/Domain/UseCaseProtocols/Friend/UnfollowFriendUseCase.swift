//
//  UnfollowFriendUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol UnfollowFriendUseCase {
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError>
}
