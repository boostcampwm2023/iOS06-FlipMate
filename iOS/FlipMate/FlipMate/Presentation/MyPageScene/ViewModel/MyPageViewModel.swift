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
    let viewDidFinish: () -> Void
}

protocol MyPageViewModelInput {
    func viewReady()
    func profileSettingsViewButtonTapped()
    func dismissButtonDidTapped()
    func signOutButtonTapped()
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
        [Constant.developer, Constant.version],
        [Constant.signout],
        [Constant.accountClosing]
    ]
    
    // MARK: - Subjects
    private lazy var tableViewDataSourceSubject = CurrentValueSubject<[[String]], Never>(myPageDataSource)
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Properties
    private let signOutUseCsae: SignOutUseCase
    private let actions: MyPageViewModelActions?
    
    private let userInfoManager: UserInfoManagerProtocol
    
    init(signOutUseCase: SignOutUseCase,
         actions: MyPageViewModelActions? = nil,
         userInfoManager: UserInfoManagerProtocol) {
        self.signOutUseCsae = signOutUseCase
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
    
    func signOutButtonTapped() {
        signOutUseCsae.signOut()
        // TODO: 코디네이터가 담당해야 할 것 같다...? 뷰의 이동이기 때문,,
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
        static let signout = NSLocalizedString("signout", comment: "")
        static let accountClosing = NSLocalizedString("accountClosing", comment: "")
    }
}
