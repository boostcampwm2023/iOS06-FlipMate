//
//  GetUserInfoUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol GetUserInfoUseCase {
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError>
}
