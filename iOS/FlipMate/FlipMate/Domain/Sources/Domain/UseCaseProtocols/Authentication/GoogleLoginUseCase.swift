//
//  GoogleLoginUseCase.swift
//  
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol GoogleLoginUseCase {
    func googleLogin(accessToken: String) async throws -> User
}
