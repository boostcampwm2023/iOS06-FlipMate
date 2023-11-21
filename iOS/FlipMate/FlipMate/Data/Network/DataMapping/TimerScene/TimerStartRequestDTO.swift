//
//  TimerStartDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/21/23.
//

import Foundation

struct TimerStartRequestDTO: Encodable {
    let type: String
    let currentTime: String
    let learningSeconds: Int
    let category: String
}
