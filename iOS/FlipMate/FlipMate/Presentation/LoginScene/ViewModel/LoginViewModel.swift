//
//  LoginViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation
import Combine

struct LoginViewModelActions {
    let showSignUpViewController: () -> Void
    let showTabBarController: () -> Void
    let skippedLogin: () -> Void
}

protocol LoginViewModelInput {
    func skippedLogin()
    func didFinishLoginAndIsMember()
    func didFinishLoginAndIsNotMember()
    func requestGoogleLogin(accessToken: String)
    func requestAppleLogin(accessToken: String)
}

protocol LoginViewModelOutput { 
    var isMemberPublisher: AnyPublisher<Bool?, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput

final class LoginViewModel: LoginViewModelProtocol {

    // MARK: properties
    private let googleAuthUseCase: AuthenticationUseCase
    private var cancellables: Set<AnyCancellable> = []
    private let actions: LoginViewModelActions?
    
    private let isMemberSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    init(googleAuthUseCase: AuthenticationUseCase, actions: LoginViewModelActions? = nil) {
        self.googleAuthUseCase = googleAuthUseCase
        self.actions = actions
    }
    
    // MARK: - input
    func skippedLogin() {
        actions?.skippedLogin()
    }
    
    func didFinishLoginAndIsMember() {
        self.actions?.showTabBarController()
    }
    
    func didFinishLoginAndIsNotMember() {
        actions?.showSignUpViewController()
    }

    func requestGoogleLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleAuthUseCase.googleLogin(accessToken: accessToken)

                let accessToken = response.accessToken
                try KeychainManager.saveAccessToken(token: accessToken)
                isMemberSubject.send(response.isMember)
            } catch let error {
                errorSubject.send(error)
                FMLogger.general.error("로그인 중 에러 발생 : \(error)")
            }
        }
    }
    
    func requestAppleLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleAuthUseCase.appleLogin(accessToken: accessToken)
                
                let accessToken = response.accessToken
                try KeychainManager.saveAccessToken(token: accessToken)
                isMemberSubject.send(response.isMember)
            } catch let error {
                errorSubject.send(error)
                FMLogger.general.error("로그인 중 에러 발생 : \(error)")
            }
        }
    }
    
    // MARK: - Output
    var isMemberPublisher: AnyPublisher<Bool?, Never> {
        return isMemberSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
