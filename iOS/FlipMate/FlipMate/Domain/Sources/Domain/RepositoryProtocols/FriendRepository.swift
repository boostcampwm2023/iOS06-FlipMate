//
//  FriendRepository.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation
import Combine

import Core

public protocol FriendRepository {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError>
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError>
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError>
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError>
}
