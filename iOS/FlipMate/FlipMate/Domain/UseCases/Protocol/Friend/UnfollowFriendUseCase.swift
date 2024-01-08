//
//  UnfollowFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

protocol UnfollowFriendUseCase {
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError>
}
