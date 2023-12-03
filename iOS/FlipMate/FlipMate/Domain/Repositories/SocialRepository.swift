//
//  SocialRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

protocol SocialRepository {
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError>
    func fetchMyFriend(date: Date) -> AnyPublisher<[FriendStatus], NetworkError>
}
