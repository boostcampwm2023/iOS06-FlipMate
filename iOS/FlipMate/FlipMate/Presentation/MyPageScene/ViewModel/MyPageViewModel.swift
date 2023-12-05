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
    var imageDataPublisher: AnyPublisher<Data, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
}

typealias MyPageViewModelProtocol = MyPageViewModelInput & MyPageViewModelOutput

final class MyPageViewModel: MyPageViewModelProtocol {
    private let myPageDataSource: [[String]] = [
        ["프로필 설정"],
        ["문의하기", "개발자 정보", "버전 정보"],
        ["데이터 초기화", "로그아웃"],
        ["계정 탈퇴"]
    ]
    
    private lazy var tableViewDataSourceSubject = CurrentValueSubject<[[String]], Never>(myPageDataSource)
    private var nicknameSubject = PassthroughSubject<String, Never>()
    private var imageDataSubject = PassthroughSubject<Data, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Input
    func viewReady() {
        tableViewDataSourceSubject.send(myPageDataSource)
        let nickname = UserInfoStorage.nickname
        nicknameSubject.send(nickname)
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
    
    // MARK: - Output
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> {
        return tableViewDataSourceSubject.eraseToAnyPublisher()
    }
    
    var nicknamePublisher: AnyPublisher<String, Never> {
        return nicknameSubject.eraseToAnyPublisher()
    }
    
    var imageDataPublisher: AnyPublisher<Data, Never> {
        return imageDataSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
