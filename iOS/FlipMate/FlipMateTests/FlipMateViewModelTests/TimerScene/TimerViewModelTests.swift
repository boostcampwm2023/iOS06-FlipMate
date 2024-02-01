//
//  TimerViewModel.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/8/24.
//

import Foundation
import XCTest
import Combine
@testable import FlipMate

private final class MockTimerManager: TimerManageable {
    var state: FlipMate.TimerState
    
    init(state: FlipMate.TimerState) {
        self.state = state
    }
    
    convenience init() {
        self.init(state: .resumed)
    }
    
    func start(completion: (() -> Void)?) {
        state = .resumed
    }
    
    func resume() {
        state = .resumed
    }
    
    func suspend() {
        state = .resumed
    }
    
    func cancel() {
        state = .resumed
    }
}

final class TimerViewModelTests: XCTestCase {
    private var sut: TimerViewModel!
    
    override func setUpWithError() throws {
        sut = TimerViewModel(
            startTimerUseCase: DummyStartTimerUseCase(),
            getStudyLogUseCase: DummyGetStudyLogUseCase(),
            getUserInfoUseCase: DummyGetUserInfoUseCase(),
            studingPingUseCase: DummyStudingPingUseCase(),
            patchTimeZoneUseCase: DummyPatchTimeZoneUseCase(),
            categoryManager: DummyCategoryManager(),
            userInfoManager: DummyUserInfoManager(),
            timerManager: MockTimerManager())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_디바이스_방향_아래_및_근접센서_활성화일_떄_facedown_true() {
        let expectation = XCTestExpectation()
        var receivedValue: Bool!
        let cancellable = sut.isDeviceFaceDownPublisher
            .sink { isFaceDown in
                receivedValue = isFaceDown
                expectation.fulfill()
            }
        
        sut.deviceOrientationDidChange(.faceDown)
        sut.deviceProximityDidChange(true)
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(receivedValue, true)
        cancellable.cancel()
    }
    
    func test_디바이스_방향_위_및_근접센서_활성화일_때_facedown_false() {
        let expectation = XCTestExpectation()
        var receivedValue: Bool!
        let cancellable = sut.isDeviceFaceDownPublisher
            .sink { isFaceDown in
                receivedValue = isFaceDown
                expectation.fulfill()
            }
        
        sut.deviceOrientationDidChange(.faceUp)
        sut.deviceProximityDidChange(true)
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(receivedValue, false)
        cancellable.cancel()
    }
    
    func test_디바이스_방향_아래_및_근접센서_비활성화일_때_facedown_false() {
        let expectation = XCTestExpectation()
        var receivedValue: Bool!
        let cancellable = sut.isDeviceFaceDownPublisher
            .sink { isFaceDown in
                receivedValue = isFaceDown
                expectation.fulfill()
            }
        
        sut.deviceOrientationDidChange(.faceDown)
        sut.deviceProximityDidChange(false)
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(receivedValue, false)
        cancellable.cancel()
    }
    
    func test_디바이스_방향_위_및_근접센서_비활성화일_때_facedown_false() {
        let expectation = XCTestExpectation()
        var receivedValue: Bool!
        let cancellable = sut.isDeviceFaceDownPublisher
            .sink { isFaceDown in
                receivedValue = isFaceDown
                expectation.fulfill()
            }
        
        sut.deviceOrientationDidChange(.faceUp)
        sut.deviceProximityDidChange(false)
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(receivedValue, false)
        cancellable.cancel()
    }
}
