//
//  LoginViewModel.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Foundation
import Combine
import Domain
import Core

public struct LoginViewModelActions {
    let showSignUpViewController: () -> Void
    let showTabBarController: () -> Void
    let skippedLogin: () -> Void
    
    public init(showSignUpViewController: @escaping () -> Void, showTabBarController: @escaping () -> Void, skippedLogin: @escaping () -> Void) {
        self.showSignUpViewController = showSignUpViewController
        self.showTabBarController = showTabBarController
        self.skippedLogin = skippedLogin
    }
}

public protocol LoginViewModelInput {
    func skippedLogin()
    func didFinishLoginAndIsMember()
    func didFinishLoginAndIsNotMember()
    func requestGoogleLogin(accessToken: String)
    func requestAppleLogin(accessToken: String, userID: String)
}

public protocol LoginViewModelOutput {
    var isMemberPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

public typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput

public final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: properties
    private let googleLoginUseCase: GoogleLoginUseCase
    private let appleLoginUseCase: AppleLoginUseCase
    private var cancellables: Set<AnyCancellable> = []
    private let actions: LoginViewModelActions?
    
    private let isMemberSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    public init(googleLoginUseCase: GoogleLoginUseCase,
         appleLoginUseCase: AppleLoginUseCase,
         actions: LoginViewModelActions? = nil) {
        self.googleLoginUseCase = googleLoginUseCase
        self.appleLoginUseCase = appleLoginUseCase
        self.actions = actions
    }
    
    // MARK: - input
    public func skippedLogin() {
        actions?.skippedLogin()
    }
    
    public func didFinishLoginAndIsMember() {
        self.actions?.showTabBarController()
    }
    
    public func didFinishLoginAndIsNotMember() {
        actions?.showSignUpViewController()
    }
    
    public func requestGoogleLogin(accessToken: String) {
        Task {
            do {
                let response = try await self.googleLoginUseCase.googleLogin(accessToken: accessToken)
                isMemberSubject.send(response.isMember)
            } catch let error {
                errorSubject.send(error)
                FMLogger.general.error("로그인 중 에러 발생 : \(error)")
            }
        }
    }
    
    public func requestAppleLogin(accessToken: String, userID: String) {
        Task {
            do {
                let response = try await self.appleLoginUseCase.appleLogin(accessToken: accessToken, userID: userID)
                isMemberSubject.send(response.isMember)
            } catch let error {
                errorSubject.send(error)
                FMLogger.general.error("로그인 중 에러 발생 : \(error)")
            }
        }
    }
    
    // MARK: - Output
    public var isMemberPublisher: AnyPublisher<Bool, Never> {
        return isMemberSubject.eraseToAnyPublisher()
    }
    
    public var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
