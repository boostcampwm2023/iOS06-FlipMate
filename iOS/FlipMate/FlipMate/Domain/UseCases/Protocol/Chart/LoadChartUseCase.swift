//
//  LoadChartUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

protocol LoadChartUseCase {
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError>
}
