//
//  DefaultSocialUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

final class DefaultSocialUseCase: SocialUseCase {
    private let repsoitory: SocialRepository
    
    init(repsoitory: SocialRepository) {
        self.repsoitory = repsoitory
    }
    
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError> {
        return repsoitory.getMyFriend(date: date)
    }
    
    func fetchMyFriend() -> AnyPublisher<[FriendStatus], NetworkError> {
        return repsoitory.fetchMyFriend()
    }
}
