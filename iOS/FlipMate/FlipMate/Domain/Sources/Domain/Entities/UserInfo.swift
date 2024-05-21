//
//  UserInfo.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct UserInfo {
    public let name: String
    public let profileImageURL: String?
    public let email: String
    
    public init(name: String, profileImageURL: String?, email: String) {
        self.name = name
        self.profileImageURL = profileImageURL
        self.email = email
    }
}
