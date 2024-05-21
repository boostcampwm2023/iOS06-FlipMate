//
//  User.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct User {
    public let isMember: Bool
    public let accessToken: String
    
    public init(isMember: Bool, accessToken: String) {
        self.isMember = isMember
        self.accessToken = accessToken
    }
}
