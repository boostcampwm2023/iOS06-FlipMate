//
//  DefaultUserInfoUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/04.
//

import Foundation
import Combine

final class DefaultGetUserInfoUseCase: GetUserInfoUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository) {
        self.repository = repository
    }
    
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError> {
        return repository.getUserInfo()
    }
}
