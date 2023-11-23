//
//  User.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

class User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.idToken == rhs.idToken
    }
    
    let idToken: String?
    let accessToken: String?
    
    var nickname: String?
    var category: [Category]
    var totalStudyTime: TimeInterval?
    
    init(idToken: String, accessToken: String, nickname: String, category: [Category], totalStudyTime: TimeInterval) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.nickname = nickname
        self.category = category
        self.totalStudyTime = totalStudyTime
    }
}
