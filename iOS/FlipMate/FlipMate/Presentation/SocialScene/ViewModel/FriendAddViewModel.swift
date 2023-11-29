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
    var searchFreindPublisher: AnyPublisher<Friend, Never> { get }
    var searchErrorPublisher: AnyPublisher<String, Never> { get }
    var nicknameCountPublisher: AnyPublisher<Int, Never> { get }
}

typealias FriendAddViewModelProtocol = FriendAddViewModelInput & FriendAddViewModelOutput

final class FriendAddViewModel: FriendAddViewModelProtocol {
    // MARK: - Subject
    var searchResultSubject = PassthroughSubject<Friend, Never>()
    var searchErrorSubject = PassthroughSubject<String, Never>()
    var nicknameCountSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - output
    var searchFreindPublisher: AnyPublisher<Friend, Never> {
        return searchResultSubject.eraseToAnyPublisher()
    }
    
    var searchErrorPublisher: AnyPublisher<String, Never> {
        return searchErrorSubject.eraseToAnyPublisher()
    }
    
    var nicknameCountPublisher: AnyPublisher<Int, Never> {
        return nicknameCountSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    func didFollowFriend(at nickName: String) {
        // useCase 호출
    }
    
    func didSearchFriend(at nickName: String) {
        // useCase 호출
        searchResultSubject.send(Friend(nickName: nickName, profileImageURL: ""))
        searchErrorSubject.send("검색결과가 없습니다.")
    }
    
    func nicknameDidChange(at nickname: String) {
        nicknameCountSubject.send(nickname.count)
    }
}
