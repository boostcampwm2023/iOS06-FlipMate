//
//  LoginViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation
import Combine

struct LoginViewModelActions {
    let showTabBarController: () -> Void
}

protocol LoginViewModelInput {
    func didLogin()
    func requestLogin(accessToken: String)
}

protocol LoginViewModelOutput { 
    var isMemberPublisher: AnyPublisher<Bool?, Never> { get }
}

typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput

final class LoginViewModel: LoginViewModelProtocol {
    // MARK: properties
    private let googleAuthUseCase: GoogleAuthUseCase
    private let cancellables: Set<AnyCancellable> = []
    private let actions: LoginViewModelActions?
    
    private let isMemberSubject = CurrentValueSubject<Bool?, Never>(nil)
    
    var isMemberPublisher: AnyPublisher<Bool?, Never> {
        return isMemberSubject.eraseToAnyPublisher()
    }
    
    init(googleAuthUseCase: GoogleAuthUseCase, actions: LoginViewModelActions? = nil) {
        self.googleAuthUseCase = googleAuthUseCase
        self.actions = actions
    }
    
    // MARK: - input
    func didLogin() {
        actions?.showTabBarController()
    }
    
    func requestLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleAuthUseCase.googleLogin(accessToken: accessToken)
                isMemberSubject.send(response.isMember)
                
                // TODO: 추후 분기 처리 (회원가입 안했을 때 고려)
                let accessToken = response.accessToken
                try KeychainManager.saveAccessToken(token: accessToken)
                
                if response.isMember {
                    FMLogger.user.log("나는 이미 회원이야")
                    try KeychainManager.saveAccessToken(token: accessToken)
                } else {
                    FMLogger.user.log("나는 아직 회원이 아니야")
                }
            } catch {
                FMLogger.general.error("로그인 중 에러 발생")
            }
        }
    }
}
