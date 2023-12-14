//
//  GoogleLoginRepository.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

protocol AuthenticationRepository {
    func googleLogin(with accessToken: String) async throws -> User
    func appleLogin(with accessToken: String) async throws -> User
}
