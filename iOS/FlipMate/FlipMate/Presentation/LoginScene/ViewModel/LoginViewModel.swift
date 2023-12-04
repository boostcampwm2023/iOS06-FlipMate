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
    func requestLogin(accessToken: String)
}

protocol LoginViewModelOutput { 
    var isMemberPublisher: AnyPublisher<Bool?, Never> { get }
}

typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput

final class LoginViewModel: LoginViewModelProtocol {

    // MARK: properties
    private let googleAuthUseCase: GoogleAuthUseCase
    private let userInfoUseCase: UserInfoUseCase
    private var cancellables: Set<AnyCancellable> = []
    private let actions: LoginViewModelActions?
    
    private let isMemberSubject = CurrentValueSubject<Bool?, Never>(nil)
    
    var isMemberPublisher: AnyPublisher<Bool?, Never> {
        return isMemberSubject.eraseToAnyPublisher()
    }
    
    init(googleAuthUseCase: GoogleAuthUseCase, userInfoUseCase: UserInfoUseCase, actions: LoginViewModelActions? = nil) {
        self.googleAuthUseCase = googleAuthUseCase
        self.userInfoUseCase = userInfoUseCase
        self.actions = actions
    }
    
    // MARK: - input
    func skippedLogin() {
        actions?.skippedLogin()
    }
    
    func didFinishLoginAndIsMember() {
        userInfoUseCase.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.actions?.showTabBarController()
                    FMLogger.user.debug("사용자 정보를 받아오는데 성공하였습니다.")
                case .failure(let error):
                    FMLogger.user.error("사용자 정보를 받아오는데 실패하였습니다. \(error.localizedDescription)")
                }
            } receiveValue: { userInfo in
                UserInfoStorage.nickname = userInfo.name
                UserInfoStorage.profileImageURL = userInfo.profileImageURL
            }
            .store(in: &cancellables)
//        actions?.showTabBarController()
    }
    
    func didFinishLoginAndIsNotMember() {
        actions?.showSignUpViewController()
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
            } catch let error {
                FMLogger.general.error("로그인 중 에러 발생 : \(error)")
            }
        }
    }
}
