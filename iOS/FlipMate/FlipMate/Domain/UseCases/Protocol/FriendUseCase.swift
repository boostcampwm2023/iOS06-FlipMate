//
//  FriendUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

protocol FollowFriendUseCase {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError>
}

protocol UnfollowFriendUseCase {
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError>
}

protocol SearchFriendUseCase {
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError>
}

protocol LoadChartUseCase {
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError>
}
