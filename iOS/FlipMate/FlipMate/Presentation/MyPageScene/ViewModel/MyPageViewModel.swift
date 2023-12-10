//
//  MyPageViewModel.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import Foundation
import Combine

protocol MyPageViewModelInput {
    func viewReady()
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
        [Constant.editProfile],
        [Constant.contact, Constant.developer, Constant.version],
        [Constant.reset, Constant.signout],
        [Constant.accountClosing]
    ]
    
    private lazy var tableViewDataSourceSubject = CurrentValueSubject<[[String]], Never>(myPageDataSource)
    private var nicknameSubject = PassthroughSubject<String, Never>()
    private var imageURLSubject = PassthroughSubject<String, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Input
    func viewReady() {
        tableViewDataSourceSubject.send(myPageDataSource)
        let nickname = UserInfoStorage.nickname
        let imageURL = UserInfoStorage.profileImageURL
        nicknameSubject.send(nickname)
        imageURLSubject.send(imageURL)
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

private extension MyPageViewModel {
    enum Constant {
        static let editProfile = NSLocalizedString("editProfile", comment: "")
        static let contact = NSLocalizedString("contact", comment: "")
        static let version = NSLocalizedString("version", comment: "")
        static let developer = NSLocalizedString("developer", comment: "")
        static let reset = NSLocalizedString("reset", comment: "")
        static let signout = NSLocalizedString("signout", comment: "")
        static let accountClosing = NSLocalizedString("accountClosing", comment: "")
    }
}
