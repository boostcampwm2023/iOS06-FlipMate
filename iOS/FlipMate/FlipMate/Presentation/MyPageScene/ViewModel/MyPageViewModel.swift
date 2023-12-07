//
//  MyPageViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import Foundation
import Combine

struct MyPageViewModelActions {
    let showProfileSettingsView: () -> Void
}

protocol MyPageViewModelInput {
    func viewReady()
    func profileSettingsViewButtonTapped()
    func signOutButtonTapped()
}

protocol MyPageViewModelOutput {
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var imageURLPublisher: AnyPublisher<String, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias MyPageViewModelProtocol = MyPageViewModelInput & MyPageViewModelOutput

final class MyPageViewModel: MyPageViewModelProtocol {
    private let myPageDataSource: [[String]] = [
        ["프로필 수정"],
        ["문의하기", "개발자 정보", "버전 정보"],
        ["데이터 초기화", "로그아웃"],
        ["계정 탈퇴"]
    ]
    
    // MARK: - Subjects
    private lazy var tableViewDataSourceSubject = CurrentValueSubject<[[String]], Never>(myPageDataSource)
    private var nicknameSubject = PassthroughSubject<String, Never>()
    private var imageURLSubject = PassthroughSubject<String, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Properties
    private let useCase: AuthenticationUseCase
    private let actions: MyPageViewModelActions?
    
    init(authenticationUseCase: AuthenticationUseCase, actions: MyPageViewModelActions? = nil) {
        self.useCase = authenticationUseCase
        self.actions = actions
    }
    
    // MARK: - Input
    func viewReady() {
        tableViewDataSourceSubject.send(myPageDataSource)
        let nickname = UserInfoStorage.nickname
        let imageURL = UserInfoStorage.profileImageURL
        nicknameSubject.send(nickname)
        imageURLSubject.send(imageURL)
    }
    
    func profileSettingsViewButtonTapped() {
        actions?.showProfileSettingsView()
    }
    
    func signOutButtonTapped() {
        useCase.signOut()
        // TODO: 코디네이터가 담당해야 할 것 같다...? 뷰의 이동이기 때문,,
    }
    
    // MARK: - Output
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> {
        return tableViewDataSourceSubject.eraseToAnyPublisher()
    }
    
    var nicknamePublisher: AnyPublisher<String, Never> {
        return nicknameSubject.eraseToAnyPublisher()
    }
    
    var imageURLPublisher: AnyPublisher<String, Never> {
        return imageURLSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
