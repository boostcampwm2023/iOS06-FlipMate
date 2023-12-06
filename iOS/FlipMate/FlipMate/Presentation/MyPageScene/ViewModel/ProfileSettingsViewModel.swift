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
    var imageDataPublisher: AnyPublisher<Data, Never> { get }
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
    private var imageDataSubject = PassthroughSubject<Data, Never>()
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
        nameSubject.send(nickname)
        guard let url = URL(string: UserInfoStorage.profileImageURL) else {
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                self.imageDataSubject.send(data)
            } catch let error {
                self.errorSubject.send(error)
            }
        }
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
            } catch let errorBody as APIError {
                switch errorBody {
                case .errorResponse(let response):
                    switch response.statusCode {
                        // 닉네임 중복
                    case 40000:
                        isValidNickNameSubject.send(.duplicated)
                        // 이미지 유해함
                    case 40001:
                        break
                    default:
                        break
                    }
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
    
    var imageDataPublisher: AnyPublisher<Data, Never> {
        return imageDataSubject.eraseToAnyPublisher()
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
