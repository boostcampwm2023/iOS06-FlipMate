//
//  ProfileSettingsViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import Foundation
import Combine

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
    var imageURLPublisher: AnyPublisher<String, Never> { get }
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> { get }
    var isProfileImageChangedPublisher: AnyPublisher<Void, Never> { get }
    var isSignUpCompletedPublisher: AnyPublisher<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias ProfileSettingsViewModelProtocol = ProfileSettingsViewModelInput & ProfileSettingsViewModelOutput

final class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    // MARK: - Use Case
    private let useCase: ProfileSettingsUseCase
    
    // MARK: - Subjects
    private var nameSubject = PassthroughSubject<String, Never>()
    private var imageURLSubject = PassthroughSubject<String, Never>()
    private var isValidNickNameSubject = PassthroughSubject<NickNameValidationState, Never>()
    private var isProfileImageChangedSubject = PassthroughSubject<Void, Never>()
    private var isSignUpCompletedSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private let actions: ProfileSettingsViewModelActions?
    
    init(usecase: ProfileSettingsUseCase, actions: ProfileSettingsViewModelActions) {
        self.useCase = usecase
        self.actions = actions
    }
    
    // MARK: - Input
    func viewReady() {
        let nickname = UserInfoStorage.nickname
        let imageURL = UserInfoStorage.profileImageURL
        nameSubject.send(nickname)
        imageURLSubject.send(imageURL)
    }
    
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
    
    func profileImageChanged() {
        isProfileImageChangedSubject.send()
    }
    
    func signUpButtonTapped(userName: String, profileImageData: Data) {
        Task {
            do {
                let userInfo = try await useCase.setupProfileInfo(nickName: userName, profileImageData: profileImageData)
                isSignUpCompletedSubject.send()
                UserInfoStorage.nickname = userInfo.name
                UserInfoStorage.profileImageURL = userInfo.profileImageURL ?? ""
                DispatchQueue.main.async {
                    self.actions?.didFinishSignUp()
                }
            } catch let error {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Output
    var nicknamePublisher: AnyPublisher<String, Never> {
        return nameSubject.eraseToAnyPublisher()
    }
    
    var imageURLPublisher: AnyPublisher<String, Never> {
        return imageURLSubject.eraseToAnyPublisher()
    }
    var isValidNickNamePublisher: AnyPublisher<NickNameValidationState, Never> {
        return isValidNickNameSubject
            .eraseToAnyPublisher()
    }
    
    var isProfileImageChangedPublisher: AnyPublisher<Void, Never> {
        return isProfileImageChangedSubject
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
