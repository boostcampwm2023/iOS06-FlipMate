//
//  DummyUseCases.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/17/24.
//

import Foundation
import Combine
@testable import FlipMate

final class DummyStartTimerUseCase: StartTimerUseCase {
    func startTimer(startTime: Date, categoryId: Int?) -> AnyPublisher<Void, FlipMate.NetworkError> {
        return PassthroughSubject<Void, FlipMate.NetworkError>().eraseToAnyPublisher()
    }
}

final class DummyGetStudyLogUseCase: GetStudyLogUseCase {
    func getStudyLog() -> AnyPublisher<FlipMate.StudyLog, FlipMate.NetworkError> {
        return PassthroughSubject<FlipMate.StudyLog, FlipMate.NetworkError>().eraseToAnyPublisher()

    }
}

final class DummyGetUserInfoUseCase: GetUserInfoUseCase {
    func getUserInfo() -> AnyPublisher<FlipMate.UserInfo, FlipMate.NetworkError> {
        return PassthroughSubject<FlipMate.UserInfo, FlipMate.NetworkError>().eraseToAnyPublisher()

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
