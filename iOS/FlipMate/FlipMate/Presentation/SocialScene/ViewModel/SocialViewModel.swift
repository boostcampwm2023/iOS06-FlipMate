//
//  SocialViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

struct SocialViewModelActions {
    var showFriendAddViewController: () -> Void
}

protocol SocialViewModelInput {
    func freindAddButtonDidTapped()
}

protocol SocialViewModelOutput {
    
}

typealias SocialViewModelProtocol = SocialViewModelInput & SocialViewModelOutput

final class SocialViewModel: SocialViewModelProtocol {
    
    private let actions: SocialViewModelActions?
    
    init(actions: SocialViewModelActions? = nil) {
        self.actions = actions
    }
    
    func freindAddButtonDidTapped() {
        actions?.showFriendAddViewController()
    }
}
