//
//  MyPageViewModel.swift
//
//
//  Created by 권승용 on 6/3/24.
//

import Foundation
import Combine
import Core
import Domain

public struct MyPageViewModelActions {
    let showProfileSettingsView: () -> Void
    let showPrivacyPolicyView: () -> Void
    let viewDidFinish: () -> Void
    
    public init(showProfileSettingsView: @escaping () -> Void, showPrivacyPolicyView: @escaping () -> Void, viewDidFinish: @escaping () -> Void) {
        self.showProfileSettingsView = showProfileSettingsView
        self.showPrivacyPolicyView = showPrivacyPolicyView
        self.viewDidFinish = viewDidFinish
    }
}

public protocol MyPageViewModelInput {
    func viewReady()
    func profileSettingsViewButtonTapped()
    func privacyPolicyViewButtonTapped()
    func dismissButtonDidTapped()
    func signOutButtonTapped()
    func withdrawButtonTapped()
}

public protocol MyPageViewModelOutput {
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> { get }
    var nicknamePublisher: AnyPublisher<String, Never> { get }
    var imageURLPublisher: AnyPublisher<String?, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

public typealias MyPageViewModelProtocol = MyPageViewModelInput & MyPageViewModelOutput

public final class MyPageViewModel: MyPageViewModelProtocol {
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
    
    private let userInfoManager: UserInfoManageable
    
    public init(signOutUseCase: SignOutUseCase,
         withdrawUseCase: WithdrawUseCase,
         actions: MyPageViewModelActions? = nil,
         userInfoManager: UserInfoManageable) {
        self.signOutUseCsae = signOutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.actions = actions
        self.userInfoManager = userInfoManager
    }
    
    // MARK: - Input
    public func viewReady() {
        tableViewDataSourceSubject.send(myPageDataSource)
    }
    
    public func profileSettingsViewButtonTapped() {
        actions?.showProfileSettingsView()
    }
    
    public func privacyPolicyViewButtonTapped() {
        actions?.showPrivacyPolicyView()
    }
    
    public func signOutButtonTapped() {
        signOutUseCsae.signOut()
    }
    
    public func withdrawButtonTapped() {
        Task {
            try await withdrawUseCase.withdraw()
        }
    }
    
    public func dismissButtonDidTapped() {
        actions?.viewDidFinish()
    }
    
    // MARK: - Output
    public var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> {
        return tableViewDataSourceSubject.eraseToAnyPublisher()
    }
    
    public var nicknamePublisher: AnyPublisher<String, Never> {
        return userInfoManager.nicknameChangePublisher
    }
    
    public var imageURLPublisher: AnyPublisher<String?, Never> {
        return userInfoManager.profileImageChangePublihser
    }
    
    public var errorPublisher: AnyPublisher<Error, Never> {
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
