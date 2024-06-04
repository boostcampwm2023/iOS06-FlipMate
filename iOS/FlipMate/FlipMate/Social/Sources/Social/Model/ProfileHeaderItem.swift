//
//  File.swift
//  
//
//  Created by 권승용 on 6/2/24.
//

import Foundation

public struct ProfileHeaderItem {
    let nickname: String
    let profileImageURL: String?
    let learningTime: Int
    
    public init(nickname: String, profileImageURL: String?, learningTime: Int) {
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.learningTime = learningTime
    }
}
