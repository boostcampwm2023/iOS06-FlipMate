//
//  SearchFriendUseCase.swift
//  FlipMate
//
//  Created by 권승용 on 1/7/24.
//

import Core
import Foundation
import Combine

protocol SearchFriendUseCase {
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError>
}
