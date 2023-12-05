//
//  StudyLog.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation

struct StudyLog {
    var totalTime: Int
    var category: [Category]
}

struct DailyChartLog: Identifiable {
    let id: UUID = UUID()
    
    var studyLog: StudyLog
    var percentage: Double
}

struct WeeklyChartLog: Identifiable {
    let id: UUID = UUID()
    
    var totalTime: Int
    var dailyData: [Int]
    var primaryCategory: String?
    var percentage: Double
}
