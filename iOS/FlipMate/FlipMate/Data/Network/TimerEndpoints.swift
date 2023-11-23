//
//  TimerEndpoints.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation

/// Timer 기능 API 통신을 위한 Endpoint을 생성해주는 객체
struct TimerEndpoints {
    /// Timer 시작 Endpoint을 생성해주는 메소드
    static func startTimer(with timerStartRequestDTO: TimerStartRequestDTO) -> EndPoint<TimerStartResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(timerStartRequestDTO)
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: "/study-logs",
            method: .post,
            data: data
        )
    }
    /// Timer 종료 Endpoint을 생성해주는 메소드
    static func stopTimer(with timerFinishRequestDTO: TimerFinishRequestDTO) -> EndPoint<TimerFinishResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(timerFinishRequestDTO)
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: "/study-logs",
            method: .post,
            data: data
        )
    }
}
