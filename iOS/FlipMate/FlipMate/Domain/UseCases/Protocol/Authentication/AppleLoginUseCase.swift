//
//  AppleLoginUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation

protocol AppleLoginUseCase {
    func appleLogin(accessToken: String) async throws -> User
}
