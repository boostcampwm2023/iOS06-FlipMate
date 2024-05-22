//
//  DefaultGoogleAuthRepository.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

import Domain
import Network

public final class DefaultAuthenticationRepository: AuthenticationRepository {
    private let provider: Providable
    
    public init(provider: Providable) {
        self.provider = provider
    }
    
    public func googleLogin(with accessToken: String) async throws -> User {
        let requestDTO = GoogleAuthRequestDTO(accessToken: accessToken)
        let endpoint = AuthenticationEndpoints.enterGoogleLogin(requestDTO)
        let responseDTO = try await provider.request(with: endpoint)
        
        return User(isMember: responseDTO.isMember, accessToken: responseDTO.accessToken)
    }
    
    public func appleLogin(with identityToken: String) async throws -> User {
        let requestDTO = AppleAuthRequestDTO(identityToken: identityToken)
        let endpoint = AuthenticationEndpoints.enterAppleLogin(requestDTO)
        let responseDTO = try await provider.request(with: endpoint)
        
        return User(isMember: responseDTO.isMember, accessToken: responseDTO.accessToken)
    }
    
    public func withdraw() async throws {
        let endpoint = AuthenticationEndpoints.withdraw()
        _ = try await provider.request(with: endpoint)
    }
}
