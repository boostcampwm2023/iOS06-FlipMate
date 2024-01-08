//
//  SocialUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

protocol GetFriendsUseCase {
    func getMyFriend(date: Date) -> AnyPublisher<[Friend], NetworkError>
}
