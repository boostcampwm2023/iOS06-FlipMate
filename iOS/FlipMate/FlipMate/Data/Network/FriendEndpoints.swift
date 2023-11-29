//
//  FriendEndpoints.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation

struct FriendEndpoints {
    static func followFriend(with firendFollowRequestDTO: FriendFollowReqeustDTO) -> EndPoint<StatusResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(firendFollowRequestDTO)
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.friend,
            method: .post)
    }
    
    static func searchFriend(at nickname: String) -> EndPoint<UserProfileResposeDTO> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.user + "/profile?nickname=\(nickname)",
            method: .get)
    }
}
