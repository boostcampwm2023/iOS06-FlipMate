//
//  FriendSearchResult.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

// TODO: 얘는 Entity에 있으면 안될듯
public enum FriendSearchStatus: Int {
    case alreayFriend = 20002
    case myself = 20001
    case notFriend = 20000
    case unknown = 0
}

public struct FriendSearchResult {
    public let status: FriendSearchStatus
    public let imageURL: String?
    
    public init(status: FriendSearchStatus, imageURL: String?) {
        self.status = status
        self.imageURL = imageURL
    }
}
