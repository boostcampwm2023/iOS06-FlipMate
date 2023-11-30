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

protocol SocialDetailViewModelOutput {
    
}

typealias SocialDetailViewModelProtocol = SocialDetailViewModelInput & SocialDetailViewModelOutput

final class SocialDetailViewModel: SocialDetailViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private var friendInfo: FriendInfo
    private var friendUseCase: FriendUseCase
    
    private lazy var profileImageURLSubject = CurrentValueSubject<String, Never>(friendInfo.friend.profileImageURL)
    private lazy var nicknameSubject = CurrentValueSubject<String, Never>(friendInfo.friend.nickName)
    
    init(friendInfo: FriendInfo, friendUseCase: FriendUseCase) {
        self.friendInfo = friendInfo
        self.friendUseCase = friendUseCase
    }
    
    func didUnfollowFriend() {
        friendUseCase.unfollow(at: friendInfo.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("팔로우 취소 성공")
                case .failure(let error):
                    FMLogger.friend.error("팔로우 취소 에러 발생 \(error)")
                }
            } receiveValue: { _ in
                // TODO: - Coordinator로 화면 전환
            }
            .store(in: &cancellables)
    }
}
