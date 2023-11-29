//
//  FriendAddViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

protocol FriendAddViewModelInput {
    func nicknameDidChange(at nickname: String)
    func didFollowFriend(at nickName: String)
    func didSearchFriend(at nickName: String)
}

protocol FriendAddViewModelOutput {
    var myNicknamePublihser: AnyPublisher<String, Never> { get }
    var searchFreindPublisher: AnyPublisher<Friend, Never> { get }
    var searchErrorPublisher: AnyPublisher<Void, Never> { get }
    var nicknameCountPublisher: AnyPublisher<Int, Never> { get }
}

typealias FriendAddViewModelProtocol = FriendAddViewModelInput & FriendAddViewModelOutput

final class FriendAddViewModel: FriendAddViewModelProtocol {
    // MARK: - Subject
    private lazy var myNicknameSubject = CurrentValueSubject<String, Never>(myNickname)
    private var searchResultSubject = PassthroughSubject<Friend, Never>()
    private var searchErrorSubject = PassthroughSubject<Void, Never>()
    private var nicknameCountSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Properties
    private let myNickname: String
    
    init(myNickname: String) {
        self.myNickname = myNickname
    }
    
    // MARK: - output
    var searchFreindPublisher: AnyPublisher<Friend, Never> {
        return searchResultSubject.eraseToAnyPublisher()
    }
    
    var searchErrorPublisher: AnyPublisher<Void, Never> {
        return searchErrorSubject.eraseToAnyPublisher()
    }
    
    var nicknameCountPublisher: AnyPublisher<Int, Never> {
        return nicknameCountSubject.eraseToAnyPublisher()
    }
    
    var myNicknamePublihser: AnyPublisher<String, Never> {
        return myNicknameSubject.eraseToAnyPublisher()
    }

    // MARK: - Input
    func didFollowFriend(at nickName: String) {
        // useCase 호출
    }
    
    func didSearchFriend(at nickName: String) {
        // useCase 호출
        searchResultSubject.send(Friend(nickName: nickName, profileImageURL: ""))
    }
    
    func nicknameDidChange(at nickname: String) {
        nicknameCountSubject.send(nickname.count)
    }
}
