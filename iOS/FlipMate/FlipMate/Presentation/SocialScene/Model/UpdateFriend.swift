//
//  UpdateFriend.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/03.
//

import Foundation

class UpdateFriend {
    var id: Int
    var currentLearningTime: Int
    
    init(id: Int, currentLearningTime: Int) {
        self.id = id
        self.currentLearningTime = currentLearningTime
    }
}

extension UpdateFriend: Hashable {
    static func == (lhs: UpdateFriend, rhs: UpdateFriend) -> Bool {
        return lhs.id == rhs.id && lhs.currentLearningTime == rhs.currentLearningTime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(currentLearningTime)
    }
}
