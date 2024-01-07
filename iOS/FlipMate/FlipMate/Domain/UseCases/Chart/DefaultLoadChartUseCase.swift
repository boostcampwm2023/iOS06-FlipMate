//
//  DefaultLoginChartUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Foundation
import Combine

final class DefaultLoadChartUseCase: LoadChartUseCase {
    private let repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        return repository.loadChart(at: id)
    }
}
