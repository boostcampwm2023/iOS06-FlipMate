//
//  UserInfoRepository.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/04.
//

import Core
import Foundation
import Combine

protocol UserInfoRepository {
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError>
    func patchTimeZone(date: Date) async throws
}
