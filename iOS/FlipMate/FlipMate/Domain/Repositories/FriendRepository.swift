//
//  FriendRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

protocol FriendRepository {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError>
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError>
    func search(at nickname: String) -> AnyPublisher<String?, NetworkError>
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError>
}
