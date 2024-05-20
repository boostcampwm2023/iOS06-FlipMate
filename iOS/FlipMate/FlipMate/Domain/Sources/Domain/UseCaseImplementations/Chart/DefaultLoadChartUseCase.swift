//
//  DefaultLoadChartUseCase.swift
//
//
//  Created by 권승용 on 5/21/24.
//

import Foundation
import Combine

import Core

public final class DefaultLoadChartUseCase: LoadChartUseCase {
    private let repository: FriendRepository
    
    public init(repository: FriendRepository) {
        self.repository = repository
    }
    
    public func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        return repository.loadChart(at: id)
    }
}
