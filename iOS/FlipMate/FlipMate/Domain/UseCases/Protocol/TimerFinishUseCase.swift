//
//  TimerFinishUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/27.
//

import Foundation
import Combine

protocol TimerFinishUseCase {
    func finishTimer(endTime: Date, learningTime: Int, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
