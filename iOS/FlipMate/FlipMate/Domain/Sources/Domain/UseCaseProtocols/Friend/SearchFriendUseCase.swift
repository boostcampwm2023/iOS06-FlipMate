//
//  SearchFriendUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation
import Combine

import Core

public protocol SearchFriendUseCase {
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError>
}
