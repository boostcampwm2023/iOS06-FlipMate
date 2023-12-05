//
//  TimerManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation
import OSLog

/// 타이머를 관리해주는 객체
final class TimerManager {
    // MARK: - Properties
    private var state: TimerState = .suspended
    private(set) var totalTime: Int = 0
    private var startTime: TimeInterval = 0.0
    private var handler: (() -> Void)?
    private var timeInterval: DispatchTimeInterval
    
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue(label: "kr.codesquad.boostcamp8.FlipMate.backgroundTimer", qos: .userInteractive))
        timer.schedule(deadline: .now(), repeating: timeInterval)
        
        guard let handler else {
            timer.setEventHandler { [weak self] in
                guard let self = self else { return }
                self.increaseTotalTime()
            }
            return timer
        }
        
        timer.setEventHandler { [weak self] in
            self?.handler?()
        }
        return timer
    }()
    
    init(timeInterval: DispatchTimeInterval = .microseconds(100), handler: (() -> Void)? = nil) {
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
    func start(startTime: Date = Date(), completion: (() -> Void)? = nil) {
//        self.startTime = start.timeIntervalSince1970

        guard let completion else {
            resume()
            return
        }
        
        setTimer(handler: completion)
        resume()
    }
    
    /// 타이머를 재개합니다.
    func resume(resumeTime: Date = Date()) {
        guard state == .suspended else { return }
        self.startTime = resumeTime.timeIntervalSince1970
        state = .resumed
        timer.resume()
    }
    
    /// 타이머를 일시정지합니다.
    func suspend() {
        guard state == .resumed else { return }
        self.totalTime = 0
        state = .suspended
        timer.suspend()
    }
    
    /// 타이머를 종료합니다.
    func cancel() {
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
    
    func increaseTotalTime() {
        
        let nowTime = Date().timeIntervalSince1970
        let diffTime = nowTime - startTime
        // 0.0000 소수점 4번째 자리까지 0이면 수행.
        // TODO: - 너무 라이브하게 구현해서 수정 필요.
        let fourNumber = String(format: "%.4f", diffTime).split(separator: ".").map { String($0) }.last!
        if fourNumber == "0000" {
            totalTime += 1
            FMLogger.device.debug("경과시간: \(diffTime)")
        }
    }
}
