//
//  Category.swift
//  FlipMate
//
//  Created by 신민규 on 11/16/23.
//

import Foundation

class Category: Identifiable {
    var color: String
    var subject: String
    var studyTime: TimeInterval
    
    init(color: String, subject: String, studyTime: TimeInterval) {
        self.color = color
        self.subject = subject
        self.studyTime = studyTime
    }
}
