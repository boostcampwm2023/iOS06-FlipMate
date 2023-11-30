//
//  SignUpViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 11/27/23.
//

import Foundation
import Combine

protocol SignUpViewModelInput {
    func nickNameChanged(_ newNickName: String)
    func profileImageChanged(_ newImageData: Data)
    func signUpButtonTapped(userName: String, profileImageData: Data)
}

protocol SignUpViewModelOutput {
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Error> { get }
    var isSafeProfileImagePublisher: AnyPublisher<Bool, Error> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Error> { get }
}

typealias SignUpViewModelProtocol = SignUpViewModelInput & SignUpViewModelOutput

final class SignUpViewModel: SignUpViewModelProtocol {
    // MARK: - Use Case
    private let useCase: SignUpUseCase
    
    // MARK: - Subjects
    var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Error>()
    var isSafeProfileImageSubject = PassthroughSubject<Bool, Error>()
    var isSignUpCompletedSubject = PassthroughSubject<Void, Error>()
    
    init(usecase: SignUpUseCase) {
        self.useCase = usecase
    }
    
    // MARK: - Input
    func nickNameChanged(_ newNickName: String) {
        Task {
            do {
                let nickNameValidationStatus = try await useCase.isNickNameValid(newNickName)
                isValidNickNameSubject.send(nickNameValidationStatus)
            } catch let error {
                isValidNickNameSubject.send(completion: .failure(error))
            }
        }
    }
    
    func profileImageChanged(_ newImageData: Data) {
        Task {
            do {
                let isSafe = try await useCase.isSafeProfileImage(newImageData)
                isSafeProfileImageSubject.send(isSafe)
            } catch let error {
                isSafeProfileImageSubject.send(completion: .failure(error))
            }
        }
    }
    
    func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                try await useCase.signUpUser(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
            } catch let error {
                isSignUpCompletedSubject.send(completion: .failure(error))
            }
        }
    }
    
    // MARK: - Output
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Error> {
        return isValidNickNameSubject
            .eraseToAnyPublisher()
    }
    
    var isSafeProfileImagePublisher: AnyPublisher<Bool, Error> {
        return isSafeProfileImageSubject
            .eraseToAnyPublisher()
    }
    
    var isSignUpCompletedPublisher: AnyPublisher<Void, Error> {
        return isSignUpCompletedSubject
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
