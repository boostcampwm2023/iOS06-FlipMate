//
//  SocialChart.swift
//  FlipMate
//
//  Created by 신민규 on 12/4/23.
//

import Foundation

struct SocialChart {
    let myData: [Int]
    let friendData: [Int]
    let primaryCategory: String?
}

// MARK: - Components of Chart
struct StudyTime: Identifiable {
    var id: UUID = UUID()
    
    let weekday: Date
    let studyTime: Int
}

struct Series: Identifiable {
    let id: UUID = UUID()
    
    let user: String
    let studyTime: [StudyTime]
}
