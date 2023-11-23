//
//  DefaultGoogleAuthRepository.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class DefaultGoogleAuthRepository: GoogleAuthRepository {
    func login(with accessToken: String) async throws -> GoogleAuthResponseDTO {
        let requestDTO = GoogleAuthRequestDTO(accessToken: accessToken)
        let endpoint = GoogleAuthEndpoints.enterGoogleLogin(requestDTO)
        let responseDTO = try await provider.request(with: endpoint)
        
        return responseDTO
    }
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
}
