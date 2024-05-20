//
//  UserInfoRepository.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation
import Combine

import Core

public protocol UserInfoRepository {
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError>
    func patchTimeZone(date: Date) async throws
}
