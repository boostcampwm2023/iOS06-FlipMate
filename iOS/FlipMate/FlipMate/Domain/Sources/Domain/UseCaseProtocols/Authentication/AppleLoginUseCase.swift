//
//  AppleLoginUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol AppleLoginUseCase {
    func appleLogin(accessToken: String, userID: String) async throws -> User
}
