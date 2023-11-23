//
//  LoginViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation
import Combine

final class LoginViewModel {
    // MARK: properties
    private let googleAuthUseCase: GoogleAuthUseCase
    private let cancellables: Set<AnyCancellable> = []
    
    private let isMemberSubject = CurrentValueSubject<Bool?, Never>(nil)
    
    var isMemberPublisher: AnyPublisher<Bool?, Never> {
        return isMemberSubject.eraseToAnyPublisher()
    }
    
    init(googleAuthUseCase: GoogleAuthUseCase) {
        self.googleAuthUseCase = googleAuthUseCase
    }
    
    func requestLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleAuthUseCase.googleLogin(accessToken: accessToken)
                isMemberSubject.send(response.isMember)
                
                // TODO: 추후 분기 처리 (회원가입 안했을 때 고려)
                try KeyChainManager.save(userId: "FlipMate", token: Data(response.accessToken.utf8))
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
