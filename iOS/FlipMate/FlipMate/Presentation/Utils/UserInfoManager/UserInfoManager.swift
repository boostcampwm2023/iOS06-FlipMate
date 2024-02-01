//
//  UserInfoManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/10.
//

import Foundation
import Combine

protocol UserInfoManageable {
    var nicknameChangePublisher: AnyPublisher<String, Never> { get }
    var profileImageChangePublihser: AnyPublisher<String?, Never> { get }
    var totalTimeChangePublihser: AnyPublisher<Int, Never> { get }
    
    func sendCurrentNickname()
    func sendCurrentProfileImageURL()
    func updateNickname(at nickname: String)
    func updateProfileImage(at profileImageURL: String?)
    func updateTotalTime(at totalTime: Int)
    
    func initManager()
}

final class UserInfoManager: UserInfoManageable {
    // MARK: - Properties
    private var nickname: String = ""
    private var profileImageURL: String?
    private var totalTime: Int = 0
    
    // MARK: - Subjecvt
    private var nicknameChangeSubject = CurrentValueSubject<String, Never>("")
    private var profileImageChangeSubject = CurrentValueSubject<String?, Never>(nil)
    private var totalTimeChangeSubject = CurrentValueSubject<Int, Never>(0)
    
    // MARK: - Publisher
    var nicknameChangePublisher: AnyPublisher<String, Never> {
        return nicknameChangeSubject.eraseToAnyPublisher()
    }
    
    var profileImageChangePublihser: AnyPublisher<String?, Never> {
        return profileImageChangeSubject.eraseToAnyPublisher()
    }
    
    var totalTimeChangePublihser: AnyPublisher<Int, Never> {
        return totalTimeChangeSubject.eraseToAnyPublisher()
    }
    
    func sendCurrentNickname() {
        nicknameChangeSubject.send(nickname)
    }
    
    func sendCurrentProfileImageURL() {
        profileImageChangeSubject.send(profileImageURL)
    }
    
    func updateNickname(at nickname: String) {
        self.nickname = nickname
        nicknameChangeSubject.send(nickname)
    }
    
    func updateProfileImage(at profileImageURL: String?) {
        self.profileImageURL = profileImageURL
        profileImageChangeSubject.send(profileImageURL)
    }
    
    func updateTotalTime(at totalTime: Int) {
        self.totalTime = totalTime
        totalTimeChangeSubject.send(self.totalTime)
    }
    
    func initManager() {
        totalTime = 0
        profileImageURL = nil
        nickname = ""
    }
}
