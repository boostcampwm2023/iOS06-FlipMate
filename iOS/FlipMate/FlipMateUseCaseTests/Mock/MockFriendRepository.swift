//
//  MockFriendRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

final class MockFriendRepository: FriendRepository {
    private var responseType: ResponseType
    
    init(responseType: ResponseType) {
        self.responseType = responseType
    }
    
    func changeResponeType(_ reponseType: ResponseType) {
        self.responseType = reponseType
    }
    
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        
        if responseType == .success {
            let response = StatusResponseDTO(statusCode: 200, message: "성공")
            return Just(response.message).eraseToAnyPublisher()
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
    }
    
    func search(at nickname: String) -> AnyPublisher<String?, NetworkError> {
        if responseType == .success {
            let response = UserProfileResposeDTO(profileImageURL: "https://flipmate.site:3000")
            return Just(response.profileImageURL).eraseToAnyPublisher()
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
    }
}
