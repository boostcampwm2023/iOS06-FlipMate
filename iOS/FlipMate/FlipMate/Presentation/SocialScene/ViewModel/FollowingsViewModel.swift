//
//  FollowingsViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import Foundation
import Combine

struct FollowingsViewModelActions {
    let viewDidFinish: () -> Void
}

protocol FollowingsViewModelInput {
    func followingButtonTouched()
}

protocol FollowingsViewModelOutput {
    var tableViewDataSourcePublisher: AnyPublisher<[[String]], Never> { get }
}

typealias FollowingsViewModelProtocol = FollowingsViewModelInput & FollowingsViewModelOutput

final class FollowingsViewModel: FollowingsViewModelProtocol {
    
}
