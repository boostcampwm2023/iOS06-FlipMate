//
//  DefaultTimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation

/// 타이머 작동 비즈니스 로직을 가지고 있는 Usecase
struct DefaultTimerUseCase: TimerUseCase {
    /// 타이머 작동
    func startTimer(startTime: Date) {}
    /// 타이머 재개
    func resumeTimer() {}
    /// 타이머 일시정지
    func suspendTimer() {}
    /// 타이머 종료
    func stopTimer(stopTime: Date) {}
}
