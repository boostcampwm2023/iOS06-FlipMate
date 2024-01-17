//
//  DummyManagers.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/17/24.
//

import Foundation
import Combine
@testable import FlipMate

final class DummyCategoryManager: CategoryManagable {
    var categoryDidChangePublisher: AnyPublisher<[FlipMate.Category], Never>
    
    init(categoryDidChangePublisher: AnyPublisher<[FlipMate.Category], Never>) {
        self.categoryDidChangePublisher = categoryDidChangePublisher
    }
    
    convenience init() {
        let categoryDidChangePublisher = PassthroughSubject<[FlipMate.Category], Never>().eraseToAnyPublisher()
        self.init(categoryDidChangePublisher: categoryDidChangePublisher)
    }
    
    func replace(categories: [FlipMate.Category]) {
        return
    }
    
    func change(category: FlipMate.Category) {
        return
    }
    
    func removeCategory(categoryId: Int) {
        return
    }
    
    func append(category: FlipMate.Category) {
        return
    }
    
    func findCategory(categoryId: Int) -> FlipMate.Category? {
        return nil
    }
    
    func numberOfCategory() -> Int {
        return 0
    }
}

final class DummyUserInfoManager: UserInfoManagable {
    var nicknameChangePublisher: AnyPublisher<String, Never>
    
    var profileImageChangePublihser: AnyPublisher<String?, Never>
    
    var totalTimeChangePublihser: AnyPublisher<Int, Never>
    
    init(nicknameChangePublisher: AnyPublisher<String, Never>,
         profileImageChangePublihser: AnyPublisher<String?, Never>,
         totalTimeChangePublihser: AnyPublisher<Int, Never>) {
        self.nicknameChangePublisher = nicknameChangePublisher
        self.profileImageChangePublihser = profileImageChangePublihser
        self.totalTimeChangePublihser = totalTimeChangePublihser
    }
    
    convenience init() {
        let nicknameChangePublisher = PassthroughSubject<String, Never>().eraseToAnyPublisher()
        let profileImageChangePublihser = PassthroughSubject<String?, Never>().eraseToAnyPublisher()
        let totalTimeChangePublihser = PassthroughSubject<Int, Never>().eraseToAnyPublisher()
        self.init(nicknameChangePublisher: nicknameChangePublisher,
                  profileImageChangePublihser: profileImageChangePublihser,
                  totalTimeChangePublihser: totalTimeChangePublihser)
    }
    
    func sendCurrentNickname() {
        return
    }
    
    func sendCurrentProfileImageURL() {
        return
    }
    
    func updateNickname(at nickname: String) {
        return
    }
    
    func updateProfileImage(at profileImageURL: String?) {
        return
    }
    
    func updateTotalTime(at totalTime: Int) {
        return
    }
    
    func initManager() {
        return
    }
}

final class DummyTimerManager: TimerManagable {
    var state: FlipMate.TimerState
    
    init(state: FlipMate.TimerState) {
        self.state = state
    }
    
    convenience init() {
        self.init(state: .cancled)
    }
    
    func start(completion: (() -> Void)?) {
        return
    }
    
    func resume() {
        return
    }
    
    func suspend() {
        return
    }
    
    func cancel() {
        return
    }
}
