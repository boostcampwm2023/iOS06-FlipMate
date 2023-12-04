//
//  UserInfoUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/04.
//

import Foundation
import Combine

protocol UserInfoUseCase {
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError>
}
