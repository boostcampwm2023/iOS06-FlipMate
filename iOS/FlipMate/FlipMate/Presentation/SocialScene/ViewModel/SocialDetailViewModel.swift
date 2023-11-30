//
//  SocialDetailViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation
import Combine

protocol SocialDetailViewModelInput {
    func didUnfollowFriend()
}

typealias SocialDetailViewModelProtocol = SocialDetailViewModelInput

final class SocialDetailViewModel: SocialDetailViewModelProtocol {
    func didUnfollowFriend() {
        
    }
}
