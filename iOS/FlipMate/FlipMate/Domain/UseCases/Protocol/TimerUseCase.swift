//
//  TimerUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/15.
//

import Foundation

/// 타이머 Usecase을 추상화한 프로토콜
protocol TimerUseCase {
    /// 타이머 작동
    func startTimer(startTime: Date)
    /// 타이머 재개
    func resumeTimer(resumeTime: Date)
    /// 타이머 일시정지
    func suspendTimer() -> Int
    /// 타이머 종료
    func stopTimer(stopTime: Date)
}
