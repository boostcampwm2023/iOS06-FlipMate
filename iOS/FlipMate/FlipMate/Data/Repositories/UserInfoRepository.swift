//
//  UserInfoRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/04.
//

import Foundation
import Combine

final class DefaultUserInfoRepository: UserInfoRepository {
    private let provider: Providable
    
    init(provider: Providable) {
        self.provider = provider
    }
    
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError> {
        let endpoint = SignUpEndpoints.userInfo()
        return provider.request(with: endpoint)
            .map { response -> UserInfo in
                return UserInfo(
                    name: response.nickName,
                    profileImageURL: response.imageURL,
                    email: response.email)
            }
            .eraseToAnyPublisher()
    }
}
