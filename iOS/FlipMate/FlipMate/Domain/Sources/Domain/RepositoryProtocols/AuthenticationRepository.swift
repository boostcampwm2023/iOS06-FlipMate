//
//  AuthenticationRepository.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public protocol AuthenticationRepository {
    func googleLogin(with accessToken: String) async throws -> User
    func appleLogin(with accessToken: String) async throws -> User
    func withdraw() async throws
}
