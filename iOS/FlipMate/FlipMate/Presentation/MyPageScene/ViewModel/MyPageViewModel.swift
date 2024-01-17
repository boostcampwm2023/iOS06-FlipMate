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
    let showPrivacyPolicyView: () -> Void
    let viewDidFinish: () -> Void
}

protocol MyPageViewModelInput {
    func viewReady()
    func profileSettingsViewButtonTapped()
    func privacyPolicyViewButtonTapped()
    func dismissButtonDidTapped()
    func signOutButtonTapped()
    func withdrawButtonTapped()
}

protocol MyPageViewModelOutput {
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var imageURLPublisher: AnyPublisher<String?, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias MyPageViewModelProtocol = MyPageViewModelInput & MyPageViewModelOutput

final class MyPageViewModel: MyPageViewModelProtocol {
    private let myPageDataSource: [[String]] = [
        [Constant.editProfile],
        [Constant.developer, Constant.version, Constant.privacyPolicy],
        [Constant.signout],
        [Constant.withdrawal]
    ]
    
    // MARK: - Subjects
    private lazy var tableViewDataSourceSubject = CurrentValueSubject<[[String]], Never>(myPageDataSource)
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Properties
    private let signOutUseCsae: SignOutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let actions: MyPageViewModelActions?
    
    private let userInfoManager: UserInfoManagable
    
    init(signOutUseCase: SignOutUseCase,
         withdrawUseCase: WithdrawUseCase,
         actions: MyPageViewModelActions? = nil,
         userInfoManager: UserInfoManagable) {
        self.signOutUseCsae = signOutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.actions = actions
        self.userInfoManager = userInfoManager
    }
    
    // MARK: - Input
    func viewReady() {
        tableViewDataSourceSubject.send(myPageDataSource)
    }
    
    func profileSettingsViewButtonTapped() {
        actions?.showProfileSettingsView()
    }
    
    func privacyPolicyViewButtonTapped() {
        actions?.showPrivacyPolicyView()
    }
    
    func signOutButtonTapped() {
        signOutUseCsae.signOut()
    }
    
    func withdrawButtonTapped() {
        Task {
            try await withdrawUseCase.withdraw()
        }
    }
    
    func dismissButtonDidTapped() {
        actions?.viewDidFinish()
    }
    
    // MARK: - Output
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> {
        return tableViewDataSourceSubject.eraseToAnyPublisher()
    }
    
    var nicknamePublisher: AnyPublisher<String, Never> {
        return userInfoManager.nicknameChangePublisher
    }
    
    var imageURLPublisher: AnyPublisher<String?, Never> {
        return userInfoManager.profileImageChangePublihser
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}

private extension MyPageViewModel {
    enum Constant {
        static let editProfile = NSLocalizedString("editProfile", comment: "")
        static let version = NSLocalizedString("version", comment: "")
        static let developer = NSLocalizedString("developer", comment: "")
        static let privacyPolicy = NSLocalizedString("privacyPolicy", comment: "")
        static let signout = NSLocalizedString("signout", comment: "")
        static let withdrawal = NSLocalizedString("withdrawal", comment: "")
    }
}
