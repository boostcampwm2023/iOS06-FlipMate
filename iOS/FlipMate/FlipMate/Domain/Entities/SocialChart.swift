//
//  SocialChart.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation

struct SocialChart {
    let myData: [Int]
    let friendData: [Int]
    let primaryCategory: String?
}

struct StudyTime: Identifiable {
    var id: UUID = UUID()
    
    let weekday: Date
    let studyTime: Int
}

struct Series: Identifiable {
    var id: UUID = UUID()
    
    let user: String
    let studyLog: [StudyTime]
}
