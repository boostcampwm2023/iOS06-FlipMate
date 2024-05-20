//
//  SocialRepository.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation
import Combine

import Core

public protocol SocialRepository {
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError>
    func fetchMyFriend(date: Date) -> AnyPublisher<[FriendStatus], NetworkError>
}
