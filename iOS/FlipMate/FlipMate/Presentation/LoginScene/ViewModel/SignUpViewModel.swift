//
//  SignUpViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 11/27/23.
//

import Foundation
import Combine

struct SignUpViewModelActions {
    let didFinishSignUp: () -> Void
}

protocol SignUpViewModelInput {
    func nickNameChanged(_ newNickName: String)
    func signUpButtonTapped(userName: String, profileImageData: Data)
}

protocol SignUpViewModelOutput {
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> { get }
    var imageNotSafePublisher: AnyPublisher<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias SignUpViewModelProtocol = SignUpViewModelInput & SignUpViewModelOutput

final class SignUpViewModel: SignUpViewModelProtocol {
    // MARK: - Use Case
    private let useCase: ProfileSettingsUseCase
    
    // MARK: - Subjects
    private var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Never>()
    private var isSafeProfileImageSubject = PassthroughSubject<Bool, Never>()
    private var isSignUpCompletedSubject = PassthroughSubject<Void, Never>()
    private var imageNotSafeSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private let actions: SignUpViewModelActions?
    
    init(usecase: ProfileSettingsUseCase, actions: SignUpViewModelActions) {
        self.useCase = usecase
        self.actions = actions
    }
    
    // MARK: - Input
    func nickNameChanged(_ newNickName: String) {
        Task {
            do {
                let nickNameValidationStatus = try await useCase.isNickNameValid(newNickName)
                isValidNickNameSubject.send(nickNameValidationStatus)
            } catch let error {
                errorSubject.send(error)
            }
        }
    }
    
    func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                _ = try await useCase.setupProfileInfo(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
                DispatchQueue.main.async {
                    self.actions?.didFinishSignUp()
                }
            } catch let errorBody as APIError {
                switch errorBody {
                case .errorResponse(let response):
                    switch response.statusCode {
                    // 닉네임 중복
                    case 40000:
                        isValidNickNameSubject.send(.duplicated)
                    // 이미지 유해함
                    case 40001:
                        imageNotSafeSubject.send()
                    default:
                        errorSubject.send(errorBody)
                    }
                }
            } catch let error {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Output
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> {
        return isValidNickNameSubject
            .eraseToAnyPublisher()
    }
    
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> {
        return isSignUpCompletedSubject
            .eraseToAnyPublisher()
    }
    
    var imageNotSafePublisher: AnyPublisher<Void, Never> {
        return imageNotSafeSubject
            .eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject
            .eraseToAnyPublisher()
    }
}
