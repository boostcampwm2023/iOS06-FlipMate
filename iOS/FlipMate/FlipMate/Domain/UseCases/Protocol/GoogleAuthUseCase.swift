//
//  GoogleLoginUseCase.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

protocol GoogleAuthUseCase {
    func googleLogin(accessToken: String) async throws -> GoogleAuthResponseDTO
}
