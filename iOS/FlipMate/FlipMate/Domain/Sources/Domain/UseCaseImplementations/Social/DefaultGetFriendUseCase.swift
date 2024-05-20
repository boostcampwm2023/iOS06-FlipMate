//
//  DefaultGetFriendsUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation
import Combine

import Core

public final class DefaultGetFriendsUseCase: GetFriendsUseCase {
    private let repsoitory: SocialRepository
    
    public init(repsoitory: SocialRepository) {
        self.repsoitory = repsoitory
    }
    
    public func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError> {
        return repsoitory.getMyFriend(date: date)
    }
}
