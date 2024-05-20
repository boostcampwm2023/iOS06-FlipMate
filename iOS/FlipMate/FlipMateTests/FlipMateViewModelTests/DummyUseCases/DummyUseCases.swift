//
//  DummyUseCases.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/17/24.
//

import Core
import Foundation
import Combine
@testable import FlipMate
@testable import Domain
@testable import Core

final class DummyStartTimerUseCase: StartTimerUseCase {
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, NetworkError> {
        return PassthroughSubject<Void, NetworkError>().eraseToAnyPublisher()
    }
}

final class DummyGetStudyLogUseCase: GetStudyLogUseCase {
    func getStudyLog() -> AnyPublisher<StudyLog, NetworkError> {
        return PassthroughSubject<StudyLog, NetworkError>().eraseToAnyPublisher()

    }
}

final class DummyGetUserInfoUseCase: GetUserInfoUseCase {
    func getUserInfo() -> AnyPublisher<UserInfo, NetworkError> {
        return PassthroughSubject<UserInfo, NetworkError>().eraseToAnyPublisher()

    }
}

final class DummyStudingPingUseCase: StudingPingUseCase {
    func studingPing() async throws {
        return
    }
}

final class DummyPatchTimeZoneUseCase: PatchTimeZoneUseCase {
    func patchTimeZone(date: Date) async throws {
        return
    }
}

final class DummyFollowFriendUseCase: FollowFriendUseCase {
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        return PassthroughSubject<String, NetworkError>().eraseToAnyPublisher()
    }
}
