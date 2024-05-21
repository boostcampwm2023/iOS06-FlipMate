//
//  FriendStatus.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct FriendStatus: Hashable {
    public let id: Int
    public let totalTime: Int
    public let startedTime: String?
    
    public init(id: Int, totalTime: Int, startedTime: String?) {
        self.id = id
        self.totalTime = totalTime
        self.startedTime = startedTime
    }
}
