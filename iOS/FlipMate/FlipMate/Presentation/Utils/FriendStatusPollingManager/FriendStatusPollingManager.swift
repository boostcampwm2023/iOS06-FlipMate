//
//  FriendStatusPollingManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/03.
//

import Foundation
import Combine

protocol FriendStatusPollingManageable {
    var updateLearningPublihser: AnyPublisher<[UpdateFriend], Never> { get }
    var updateStopFriendsPublisher: AnyPublisher<[Int], Never> { get }
    
    func update(preFriendStatusArray: [FriendStatus])
    func startPolling(friendsStatus: [FriendStatus])
    func stopPolling()
    func updateLearningFriendsBeforeLearning(friendsStatus: [FriendStatus])
}

final class FriendStatusPollingManager: FriendStatusPollingManageable {
    private var preFriendStatusArray: [FriendStatus] = []
    private var updateFriendArray: [UpdateFriend] = []
    private var timerState: TimerState = .notStarted
    private lazy var timerManager = TimerManager(timeInterval: .seconds(1), handler: increaseLearningTime)
    
    private var updateLearningFriends = PassthroughSubject<[UpdateFriend], Never>()
    private var updateStopFriends = PassthroughSubject<[Int], Never>()
    
    var updateLearningPublihser: AnyPublisher<[UpdateFriend], Never> {
        return updateLearningFriends.eraseToAnyPublisher()
    }
    
    var updateStopFriendsPublisher: AnyPublisher<[Int], Never> {
        return updateStopFriends.eraseToAnyPublisher()
    }
    
    func update(preFriendStatusArray: [FriendStatus]) {
        self.preFriendStatusArray = preFriendStatusArray
    }
    
    func startPolling(friendsStatus: [FriendStatus]) {
        self.updateLearningFriendsBeforeStop(friendsStatus: friendsStatus)
        self.updateStopFriends(friendsStatus: friendsStatus)
        timerState = .resumed
        if timerState == .notStarted {
            timerManager.start()
        } else {
            timerManager.resume()
        }
    }
    
    func stopPolling() {
        updateFriendArray = []
        timerState = .suspended
        timerManager.suspend()
    }
    
    func updateLearningFriendsBeforeLearning(friendsStatus: [FriendStatus]) {
        let learningFriendsBeforeLearning = findLearningFreindsBeforLearning(friendsStatus: friendsStatus)
        for id in learningFriendsBeforeLearning {
            guard let friend = friendsStatus.filter { $0.id == id }.first else { return }
            guard let startedTime = friend.startedTime else { continue }
            guard let date = startedTime.stringToDate(.yyyyMMddhhmmss) else { continue }
            let currentLearningTime = Int(Date().timeIntervalSince(date))
            updateFriendArray.append(UpdateFriend(id: friend.id, currentLearningTime: currentLearningTime))
        }
    }

    private func updateLearningFriendsBeforeStop(friendsStatus: [FriendStatus]) {
        let learningFriendsBeforeStop = findLearningFriendsBeforeStop(friendsStatus: friendsStatus)
        for id in learningFriendsBeforeStop {
            guard let friend = friendsStatus.filter { $0.id == id }.first else { return }
            guard let startedTime = friend.startedTime else { continue }
            guard let date = startedTime.stringToDate(.yyyyMMddhhmmss) else { continue }
            let currentLearningTime = Int(Date().timeIntervalSince(date))
            updateFriendArray.append(UpdateFriend(id: friend.id, currentLearningTime: currentLearningTime))
        }
    }
    
    private func updateStopFriends(friendsStatus: [FriendStatus]) {
        let stopFreindsBeforeLearning = findStopFriendsbeforeLearning(friendsStatus: friendsStatus)
        stopCurrentLearningTime(stopIdList: stopFreindsBeforeLearning)
    }
    
    // 공부끝 -> 공부중
    private func findLearningFriendsBeforeStop(friendsStatus: [FriendStatus]) -> [Int] {
        let beforeLearning = preFriendStatusArray
            .filter { $0.startedTime == nil }
            .map { $0.id }
        let currentStop = friendsStatus
            .filter { $0.startedTime != nil }
            .map { $0.id }
        return Array(Set(beforeLearning).intersection(Set(currentStop)))
    }
    
    // 공부중 -> 공부중
    private func findLearningFreindsBeforLearning(friendsStatus: [FriendStatus]) -> [Int] {
        let beforeLearning = preFriendStatusArray
            .filter { $0.startedTime != nil }
            .map { $0.id }
        let currentLearning = friendsStatus
            .filter { $0.startedTime != nil }
            .map { $0.id }
        return Array(Set(beforeLearning).intersection(Set(currentLearning)))
    }
    
    // 공부끝 -> 공부끝
    private func findStopFrinedsBeforeStop(friendsStatus: [FriendStatus]) -> [Int] {
        let beforeStop = preFriendStatusArray
            .filter { $0.startedTime == nil }
            .map { $0.id }
        let currentStop = friendsStatus
            .filter { $0.startedTime == nil }
            .map { $0.id }
        return Array(Set(beforeStop).intersection(Set(currentStop)))
    }
    
    // 공부중 -> 공부끝
    private func findStopFriendsbeforeLearning(friendsStatus: [FriendStatus]) -> [Int] {
        let beforeLearning = preFriendStatusArray
            .filter { $0.startedTime != nil }
            .map { $0.id }
        let currentStop = friendsStatus
            .filter { $0.startedTime == nil }
            .map { $0.id }
        return Array(Set(beforeLearning).intersection(Set(currentStop)))
    }
    
    private func removeUpdateFriendsArray(at id: Int) {
        guard let target = updateFriendArray.filter { $0.id == id }.first else { return }
        guard let index = updateFriendArray.firstIndex(of: target) else { return }
        updateFriendArray.remove(at: index)
    }
    
    private func stopCurrentLearningTime(stopIdList: [Int]) {
        stopIdList.forEach {
            removeUpdateFriendsArray(at: $0)
        }
        updateStopFriends.send(stopIdList)
    }
    
    private func increaseLearningTime() {
        updateFriendArray.forEach { $0.currentLearningTime += 1 }
        updateLearningFriends.send(updateFriendArray)
    }
}
