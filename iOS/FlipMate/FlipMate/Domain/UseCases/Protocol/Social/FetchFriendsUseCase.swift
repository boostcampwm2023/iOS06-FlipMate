//
//  FetchFriendsUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

protocol FetchFriendsUseCase {
    func fetchMyFriend(date: Date) -> AnyPublisher<[FriendStatus], NetworkError>
}
