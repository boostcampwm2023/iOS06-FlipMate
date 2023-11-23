//
//  GoogleLoginRepository.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

protocol GoogleAuthRepository {
    func login(with accessToken: String) async throws -> GoogleAuthResponseDTO
}
