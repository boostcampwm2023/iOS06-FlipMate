//
//  SocialEndpoints.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

struct SocialEndpoints {
    static func getMyFreinds(date: Date) -> EndPoint<[FriendsResponseDTO]> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.friend + "?date=\(date.dateToString(format: .yyyyMMdd))",
            method: .get)
        
    }
    
    static func fetchMyFriend() -> EndPoint<[FriendStatusResponseDTO]> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.friend + "/status",
            method: .get)
    }
}
