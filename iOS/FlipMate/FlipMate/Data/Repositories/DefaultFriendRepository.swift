//
//  DefaultFriendRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

final class DefaultFriendRepository: FriendRepository {
    
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        let reqeustDTO = FriendFollowReqeustDTO(nickname: nickname)
        let endPoint = FriendEndpoints.followFriend(with: reqeustDTO)
        return provider.request(with: endPoint)
            .map { response -> String in
                return response.message
            }
            .eraseToAnyPublisher()
    }
    
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        let requestDTO = FriendUnfollowRequestDTO(id: id)
        let endPoint = FriendEndpoints.unfollowFreind(with: requestDTO)
        return provider.request(with: endPoint)
            .map { response -> String in
                return response.message
            }
            .eraseToAnyPublisher()
    }
    
    func search(at nickname: String) -> AnyPublisher<String?, NetworkError> {
        let endPoint = FriendEndpoints.searchFriend(at: nickname)
        return provider.request(with: endPoint)
            .map { response -> String? in
                return response.profileImageURL
            }
            .eraseToAnyPublisher()
    }
    
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        let requestDTO = SocialDetailRequestDTO(followingID: id, date: Date().dateToString(format: .yyyyMMdd))
        let endPoint = FriendEndpoints.loadFriendData(with: requestDTO)
        return provider.request(with: endPoint)
            .map { response -> SocialChart in
                return SocialChart(myData: response.myData, friendData: response.followingData, primaryCategory: response.primaryCategory)
            }
            .eraseToAnyPublisher()
    }
}
