//
//  TimerManager.swift
//
//
//  Created by 권승용 on 5/31/24.
//

import Foundation
import OSLog

public enum TimerState {
    case suspended // 타이머 일시정지 상태
    case resumed // 타이머 작동 상태
    case cancled // 타이머 종료 상태
    case notStarted // 타이머 시작안된 상태
}

public protocol TimerManageable {
    var state: TimerState { get }
    
    func start(completion: (() -> Void)?)
    func resume()
    func suspend()
    func cancel()
}

/// 타이머를 관리해주는 객체
public final class TimerManager: TimerManageable {
    // MARK: - Properties
    private var handler: (() -> Void)?
    private var timeInterval: DispatchTimeInterval
    public var state: TimerState = .suspended
    
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(
            flags: [],
            queue: DispatchQueue(
                label: "kr.codesquad.boostcamp8.FlipMate.backgroundTimer",
                qos: .userInteractive))
        timer.schedule(deadline: .now(), repeating: timeInterval)
        
        timer.setEventHandler { [weak self] in
            self?.handler?()
        }
        return timer
    }()
    
    public init(timeInterval: DispatchTimeInterval = .seconds(1), handler: (() -> Void)? = nil) {
        self.handler = handler
        self.timeInterval = timeInterval
    }
    
    // MARK: - deinit
    deinit {
        initTimer()
        resume()
        timer.cancel()
    }
    
    /// 타이머를 시작합니다.
    public func start(completion: (() -> Void)? = nil) {
        
        guard let completion else {
            resume()
            return
        }
        
        setTimer(handler: completion)
        resume()
    }
    
    /// 타이머를 재개합니다.
    public func resume() {
        guard state == .suspended else { return }
        state = .resumed
        timer.resume()
    }
    
    /// 타이머를 일시정지합니다.
    public func suspend() {
        guard state == .resumed else { return }
        state = .suspended
        timer.suspend()
    }
    
    /// 타이머를 종료합니다.
    public func cancel() {
        guard state != .suspended else { return }
        state = .suspended
        timer.suspend()
        initTimer()
    }
}

private extension TimerManager {
    func initTimer() {
        timer.setEventHandler(handler: nil)
        handler = nil
    }
    
    func setTimer(handler: (() -> Void)? = nil) {
        self.handler = handler
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler { [weak self] in
            self?.handler?()
        }
    }
}
