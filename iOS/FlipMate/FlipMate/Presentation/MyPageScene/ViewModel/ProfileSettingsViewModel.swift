//
//  ProfileSettingsViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import Foundation
import Combine

import Domain
import Core

struct ProfileSettingsViewModelActions {
    let didFinishSignUp: () -> Void
}

protocol ProfileSettingsViewModelInput {
    func viewReady()
    func nickNameChanged(_ newNickName: String)
    func profileImageChanged()
    func signUpButtonTapped(userName: String, profileImageData: Data)
}

protocol ProfileSettingsViewModelOutput {
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var imageURLPublisher: AnyPublisher<String?, Never> { get }
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> { get }
    var isProfileImageChangedPublisher: AnyPublisher<Void, Never> { get }
    var imageNotSafePublisher: AnyPublisher<Void, Never> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias ProfileSettingsViewModelProtocol = ProfileSettingsViewModelInput & ProfileSettingsViewModelOutput

final class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    // MARK: - Use Case
    private let validateNicknameUseCase: ValidateNicknameUseCase
    private let setupProfileInfoUseCase: SetupProfileInfoUseCase
    
    // MARK: - Subjects
    private var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Never>()
    private var isProfileImageChangedSubject = PassthroughSubject<Void, Never>()
    private var imageNotSafeSubject = PassthroughSubject<Void, Never>()
    private var isSignUpCompletedSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private let actions: ProfileSettingsViewModelActions?
    private let userInfoManager: UserInfoManageable
    
    init(validateNicknameUseCase: ValidateNicknameUseCase,
         setupProfileInfoUseCase: SetupProfileInfoUseCase,
         actions: ProfileSettingsViewModelActions?,
         userInfoManager: UserInfoManageable) {
        self.validateNicknameUseCase = validateNicknameUseCase
        self.setupProfileInfoUseCase = setupProfileInfoUseCase
        self.actions = actions
        self.userInfoManager = userInfoManager
    }
    
    // MARK: - Input
    func viewReady() {
    }
    
    func nickNameChanged(_ newNickName: String) {
        let nickNameValidationStatus = validateNicknameUseCase.isNickNameValid(newNickName)
        isValidNickNameSubject.send(nickNameValidationStatus)
    }
    
    func profileImageChanged() {
        isProfileImageChangedSubject.send()
    }
    
    func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                let userInfo = try await setupProfileInfoUseCase.setupProfileInfo(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
                userInfoManager.updateNickname(at: userInfo.name)
                userInfoManager.updateProfileImage(at: userInfo.profileImageURL)
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
    var nicknamePublisher: AnyPublisher<String, Never> {
        return userInfoManager.nicknameChangePublisher
    }
    
    var imageURLPublisher: AnyPublisher<String?, Never> {
        return userInfoManager.profileImageChangePublihser
    }
    
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> {
        return isValidNickNameSubject
            .eraseToAnyPublisher()
    }
    
    var isProfileImageChangedPublisher: AnyPublisher<Void, Never> {
        return isProfileImageChangedSubject
            .eraseToAnyPublisher()
    }
    
    var imageNotSafePublisher: AnyPublisher<Void, Never> {
        return imageNotSafeSubject
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
