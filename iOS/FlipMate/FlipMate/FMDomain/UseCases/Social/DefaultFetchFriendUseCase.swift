//
//  DefaultFetchFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Core
import Foundation
import Combine

final class DefaultFetchFriendsUseCase: FetchFriendsUseCase {
    private let repsoitory: SocialRepository
    
    init(repsoitory: SocialRepository) {
        self.repsoitory = repsoitory
    }
    
    func fetchMyFriend(date: Date) -> AnyPublisher<[FriendStatus], NetworkError> {
        return repsoitory.fetchMyFriend(date: date)
    }
}
