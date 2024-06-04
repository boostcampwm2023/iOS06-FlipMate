//
//  File.swift
//  
//
//  Created by 권승용 on 5/31/24.
//

import Foundation
import Combine

public protocol UserInfoManageable {
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

public final class UserInfoManager: UserInfoManageable {
    // MARK: - Properties
    private var nickname: String = ""
    private var profileImageURL: String?
    private var totalTime: Int = 0
    
    // MARK: - Subject
    private var nicknameChangeSubject = CurrentValueSubject<String, Never>("")
    private var profileImageChangeSubject = CurrentValueSubject<String?, Never>(nil)
    private var totalTimeChangeSubject = CurrentValueSubject<Int, Never>(0)
    
    public init() {}
    
    // MARK: - Publisher
    public var nicknameChangePublisher: AnyPublisher<String, Never> {
        return nicknameChangeSubject.eraseToAnyPublisher()
    }
    
    public var profileImageChangePublihser: AnyPublisher<String?, Never> {
        return profileImageChangeSubject.eraseToAnyPublisher()
    }
    
    public var totalTimeChangePublihser: AnyPublisher<Int, Never> {
        return totalTimeChangeSubject.eraseToAnyPublisher()
    }
    
    public func sendCurrentNickname() {
        nicknameChangeSubject.send(nickname)
    }
    
    public func sendCurrentProfileImageURL() {
        profileImageChangeSubject.send(profileImageURL)
    }
    
    public func updateNickname(at nickname: String) {
        self.nickname = nickname
        nicknameChangeSubject.send(nickname)
    }
    
    public func updateProfileImage(at profileImageURL: String?) {
        self.profileImageURL = profileImageURL
        profileImageChangeSubject.send(profileImageURL)
    }
    
    public func updateTotalTime(at totalTime: Int) {
        self.totalTime = totalTime
        totalTimeChangeSubject.send(self.totalTime)
    }
    
    public func initManager() {
        totalTime = 0
        profileImageURL = nil
        nickname = ""
    }
}
