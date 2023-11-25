//
//  DefaultGoogleAuthRepository.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class DefaultGoogleAuthRepository: GoogleAuthRepository {
    func login(with accessToken: String) async throws -> User {
        let requestDTO = GoogleAuthRequestDTO(accessToken: accessToken)
        let endpoint = GoogleAuthEndpoints.enterGoogleLogin(requestDTO)
        let responseDTO = try await provider.request(with: endpoint)
        
        return User(isMember: responseDTO.isMember, accessToken: responseDTO.accessToken)
    }
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
}
