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
    
    func search(at nickname: String) -> AnyPublisher<String?, NetworkError> {
        let endPoint = FriendEndpoints.searchFriend(at: nickname)
        return provider.request(with: endPoint)
            .map { response -> String? in
                return response.profileImageURL
            }
            .eraseToAnyPublisher()
    }
}
