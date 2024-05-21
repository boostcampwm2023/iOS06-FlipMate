//
//  DefaultGetUserInfoUseCase.swift
//  
//
//  Created by 권승용 on 5/21/24.
//

import Foundation
import Combine

import Core

public final class DefaultGetUserInfoUseCase: GetUserInfoUseCase {
    private let repository: UserInfoRepository
    
    public init(repository: UserInfoRepository) {
        self.repository = repository
    }
    
    public func getUserInfo() -> AnyPublisher<UserInfo, NetworkError> {
        return repository.getUserInfo()
    }
}
