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
    private enum TimerState {
        case suspended // 일시정지
        case resumed // 재개
        case cancled // 종료
        case finished //
    }
    
    // MARK: - Properties
    private var state: TimerState = .suspended
    private(set) var totalTime: Int = 0
    private var startTime: TimeInterval = 0.0

    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(
            flags: [],
            queue: DispatchQueue(label: "kr.codesquad.boostcamp8.FlipMate.backgroundTimer", qos: .userInteractive))
        timer.schedule(deadline: .now(), repeating: .microseconds(100))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.increaseTotalTime()
        }
        return timer
    }()
    
    // MARK: - deinit
    deinit {
        timer.cancel()
    }
    
    /// 타이머를 시작합니다.
    func start(startTime: Date) {
        self.startTime = startTime.timeIntervalSince1970
        state = .resumed
        timer.activate()
        FMLogger.device.debug("타미어를 시작합니다.")
    }
    
    /// 타이머를 재개합니다.
    func resume(resumeTime: Date) {
        guard state == .suspended else { return }
        self.startTime = resumeTime.timeIntervalSince1970
        state = .resumed
        timer.resume()
        FMLogger.device.debug("타미어를 재개합니다.")
    }
    
    /// 타이머를 일시정지합니다.
    func suspend() {
        guard state == .resumed else { return }
        self.totalTime = 0
        state = .suspended
        timer.suspend()
        FMLogger.device.debug("타미어를 일시정지합니다.")
    }
    
    /// 타이머를 종료합니다.
    func cancle() {
        state = .cancled
        timer.cancel()
        FMLogger.device.debug("타미어를 종료합니다.")
    }
}

private extension TimerManager {
    func finish() {
        state = .finished
        cancle()
    }
    
    func increaseTotalTime() {
        let nowTime = Date().timeIntervalSince1970
        let diffTime = nowTime - startTime
        // 0.0000 소수점 4번째 자리까지 0이면 수행.
        // TODO: - 너무 라이브하게 구현해서 수정 필요.
        let fourNumber = String(format: "%.4f", diffTime).split(separator: ".").map { String($0) }.last!
        if fourNumber == "0000" {
            totalTime += 1
            let time = String(self.totalTime)
            FMLogger.device.debug("경과시간: \(diffTime)")
        }
    }
}
