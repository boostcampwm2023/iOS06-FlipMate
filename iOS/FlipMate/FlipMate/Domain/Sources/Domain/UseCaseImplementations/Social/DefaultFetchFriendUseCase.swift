//
//  DefaultFetchFriendsUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation
import Combine

import Core

public final class DefaultFetchFriendsUseCase: FetchFriendsUseCase {
    private let repsoitory: SocialRepository
    
    public init(repsoitory: SocialRepository) {
        self.repsoitory = repsoitory
    }
    
    public func fetchMyFriend(date: Date) -> AnyPublisher<[FriendStatus], NetworkError> {
        return repsoitory.fetchMyFriend(date: date)
    }
}
