//
//  FinishTimerUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

protocol FinishTimerUseCase {
    func finishTimer(endTime: Date, learningTime: Int, categoryId: Int?) -> AnyPublisher<Void, NetworkError>
}
