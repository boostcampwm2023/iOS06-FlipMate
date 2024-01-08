//
//  DefaultGetFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

final class DefaultGetFriendsUseCase: GetFriendsUseCase {
    private let repsoitory: SocialRepository
    
    init(repsoitory: SocialRepository) {
        self.repsoitory = repsoitory
    }
    
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError> {
        return repsoitory.getMyFriend(date: date)
    }
}
