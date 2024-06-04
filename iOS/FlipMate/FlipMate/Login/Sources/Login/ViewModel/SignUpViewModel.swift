//
//  SignUpViewModel.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Foundation
import Combine
import Domain
import Core

public  struct SignUpViewModelActions {
    let didFinishSignUp: () -> Void
    
    public init(didFinishSignUp: @escaping () -> Void) {
        self.didFinishSignUp = didFinishSignUp
    }
}

public protocol SignUpViewModelInput {
    func nickNameChanged(_ newNickName: String)
    func signUpButtonTapped(userName: String, profileImageData: Data)
}

public protocol SignUpViewModelOutput {
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> { get }
    var imageNotSafePublisher: AnyPublisher<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

public typealias SignUpViewModelProtocol = SignUpViewModelInput & SignUpViewModelOutput

public final class SignUpViewModel: SignUpViewModelProtocol {
    // MARK: - Use Case
    private let validateNickNameUseCase: ValidateNicknameUseCase
    private let setupProfileUseCase: SetupProfileInfoUseCase
    
    // MARK: - Subjects
    private var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Never>()
    private var isSafeProfileImageSubject = PassthroughSubject<Bool, Never>()
    private var isSignUpCompletedSubject = PassthroughSubject<Void, Never>()
    private var imageNotSafeSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private let actions: SignUpViewModelActions?
    
    public init(validateNickNameUseCase: ValidateNicknameUseCase,
         setupProfileUseCase: SetupProfileInfoUseCase,
         actions: SignUpViewModelActions) {
        self.validateNickNameUseCase = validateNickNameUseCase
        self.setupProfileUseCase = setupProfileUseCase
        self.actions = actions
    }
    
    // MARK: - Input
    public func nickNameChanged(_ newNickName: String) {
        let nickNameValidationStatus = validateNickNameUseCase.isNickNameValid(newNickName)
        isValidNickNameSubject.send(nickNameValidationStatus)
    }
    
    public func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                _ = try await setupProfileUseCase.setupProfileInfo(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
                DispatchQueue.main.async {
                    self.actions?.didFinishSignUp()
                }
            } catch let errorBody as APIError {
                switch errorBody {
                case .duplicatedNickName:
                    isValidNickNameSubject.send(.duplicated)
                case .imageNotSafe:
                    imageNotSafeSubject.send()
                default:
                    errorSubject.send(errorBody)
                }
            } catch let error {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Output
    public var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> {
        return isValidNickNameSubject
            .eraseToAnyPublisher()
    }
    
    public var isSignUpCompletedPublisher: AnyPublisher<Void, Never> {
        return isSignUpCompletedSubject
            .eraseToAnyPublisher()
    }
    
    public var imageNotSafePublisher: AnyPublisher<Void, Never> {
        return imageNotSafeSubject
            .eraseToAnyPublisher()
    }
    
    public var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject
            .eraseToAnyPublisher()
    }
}
