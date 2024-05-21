//
//  Friend.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct Friend: Hashable {
    public let id: Int
    public let nickName: String
    public let profileImageURL: String?
    public let totalTime: Int
    public let startedTime: String?
    public let isStuding: Bool
    
    public init(id: Int, nickName: String, profileImageURL: String?, totalTime: Int, startedTime: String?, isStuding: Bool) {
        self.id = id
        self.nickName = nickName
        self.profileImageURL = profileImageURL
        self.totalTime = totalTime
        self.startedTime = startedTime
        self.isStuding = isStuding
    }
}
