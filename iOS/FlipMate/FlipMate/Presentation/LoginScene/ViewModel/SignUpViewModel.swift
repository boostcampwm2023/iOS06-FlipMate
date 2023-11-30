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
    func profileImageChanged(_ newImageData: Data)
    func signUpButtonTapped(userName: String, profileImageData: Data)
}

protocol SignUpViewModelOutput {
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> { get }
    var isSafeProfileImagePublisher: AnyPublisher<Bool, Never> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias SignUpViewModelProtocol = SignUpViewModelInput & SignUpViewModelOutput

final class SignUpViewModel: SignUpViewModelProtocol {
    // MARK: - Use Case
    private let useCase: SignUpUseCase
    
    // MARK: - Subjects
    private var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Never>()
    private var isSafeProfileImageSubject = PassthroughSubject<Bool, Never>()
    private var isSignUpCompletedSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private let actions: SignUpViewModelActions?
    
    init(usecase: SignUpUseCase, actions: SignUpViewModelActions) {
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
    
    func profileImageChanged(_ newImageData: Data) {
        Task {
            do {
                let isSafe = try await useCase.isSafeProfileImage(newImageData)
                isSafeProfileImageSubject.send(isSafe)
            } catch let error {
                errorSubject.send(error)
            }
        }
    }
    
    func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                try await useCase.signUpUser(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
                guard let actions = actions else {
                    FMLogger.general.error("no actions")
                    return
                }
                actions.didFinishSignUp()
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
    
    var isSafeProfileImagePublisher: AnyPublisher<Bool, Never> {
        return isSafeProfileImageSubject
            .eraseToAnyPublisher()
    }
    
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> {
        return isSignUpCompletedSubject
            .eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject
            .eraseToAnyPublisher()
    }
}

enum NickNameValidationState {
    case valid
    case lengthViolation
    case emptyViolation
    case duplicated
    
    var message: String {
        switch self {
        case .valid:
            return "사용 가능한 닉네임 입니다."
        case .lengthViolation:
            return "닉네임이 20자를 초과했습니다."
        case .emptyViolation:
            return "닉네임은 2자 이상 입력해야 합니다."
        case .duplicated:
            return "중복된 닉네임 입니다."
        }
    }
}
