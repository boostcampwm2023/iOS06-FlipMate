//
//  LoginViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

final class LoginViewModel {
    // MARK: properties
    private let googleAuthUseCase: GoogleAuthUseCase
    @Published var isMember: Bool = false
    
    init(googleAuthUseCase: GoogleAuthUseCase) {
        self.googleAuthUseCase = googleAuthUseCase
    }
    
    func requestLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleAuthUseCase.googleLogin(accessToken: accessToken)
                self.isMember = response.isMember
                
                if response.isMember {
                    FMLogger.user.log("나는 이미 회원이야")
                } else {
                    FMLogger.user.log("나는 아직 회원이 아니야")
                }
            } catch {
                FMLogger.general.error("로그인 중 에러 발생")
            }
        }
    }
}
