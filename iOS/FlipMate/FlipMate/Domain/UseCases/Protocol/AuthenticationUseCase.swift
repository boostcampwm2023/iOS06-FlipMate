//
//  GoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

protocol AuthenticationUseCase {
    func googleLogin(accessToken: String) async throws -> User
    func appleLogin(accessToken: String) async throws -> User
    func signOut()
    func withdraw()
}
