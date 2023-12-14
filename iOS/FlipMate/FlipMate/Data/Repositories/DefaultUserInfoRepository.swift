//
//  DefaultUserInfoRepository.swift
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
        let endpoint = UserInfoEndpoints.userInfo()
        return provider.request(with: endpoint)
            .map { response -> UserInfo in
                return UserInfo(
                    name: response.nickname,
                    profileImageURL: response.imageURL,
                    email: response.email)
            }
            .eraseToAnyPublisher()
    }
    
    func patchTimeZone(date: Date) async throws {
        let reqeust = TimeZoneRequestDTO(timezone: date.dateToString(format: .ZZZZZ))
        let endpoint = UserInfoEndpoints.patchTimeZone(with: reqeust)
        _ = try await provider.request(with: endpoint)
    }
}
