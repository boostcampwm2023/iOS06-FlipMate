//
//  SocialUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

protocol SocialUseCase {
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError>
    func fetchMyFriend() -> AnyPublisher<[FriendStatus], NetworkError>
}

