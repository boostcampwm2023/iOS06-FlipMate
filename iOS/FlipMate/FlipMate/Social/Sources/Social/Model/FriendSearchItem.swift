//
//  File.swift
//  
//
//  Created by 권승용 on 6/2/24.
//

import Foundation
import Domain

public struct FreindSeacrhItem {
    let nickname: String
    let iamgeURL: String?
    let status: FriendSearchStatus
    
    public init(nickname: String, iamgeURL: String?, status: FriendSearchStatus) {
        self.nickname = nickname
        self.iamgeURL = iamgeURL
        self.status = status
    }
}
