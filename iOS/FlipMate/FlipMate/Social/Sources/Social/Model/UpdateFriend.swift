//
//  File.swift
//  
//
//  Created by 권승용 on 6/2/24.
//

import Foundation

// class일 필요가 있을까?
public final class UpdateFriend {
    var id: Int
    var currentLearningTime: Int
    
    public init(id: Int, currentLearningTime: Int) {
        self.id = id
        self.currentLearningTime = currentLearningTime
    }
}

extension UpdateFriend: Hashable {
    public static func == (lhs: UpdateFriend, rhs: UpdateFriend) -> Bool {
        return lhs.id == rhs.id && lhs.currentLearningTime == rhs.currentLearningTime
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(currentLearningTime)
    }
}
