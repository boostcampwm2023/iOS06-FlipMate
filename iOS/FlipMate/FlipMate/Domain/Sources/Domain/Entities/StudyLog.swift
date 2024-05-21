//
//  StudyLog.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct StudyLog {
    public var totalTime: Int
    public var category: [Category]
    
    public init(totalTime: Int, category: [Category]) {
        self.totalTime = totalTime
        self.category = category
    }
}

public struct CategoryChartLog: Identifiable {
    public let id: UUID = UUID()
    
    public var studyLog: StudyLog
    public var percentage: Double
    
    public init(studyLog: StudyLog, percentage: Double) {
        self.studyLog = studyLog
        self.percentage = percentage
    }
}

public struct WeeklyChartLog: Identifiable {
    public let id: UUID = UUID()
    
    public var totalTime: Int
    public var dailyData: [DailyData]
    public var primaryCategory: String?
    public var percentage: Double
    
    public init(totalTime: Int, dailyData: [DailyData], primaryCategory: String? = nil, percentage: Double) {
        self.totalTime = totalTime
        self.dailyData = dailyData
        self.primaryCategory = primaryCategory
        self.percentage = percentage
    }
}

public struct DailyData: Identifiable {
    public let id: UUID = UUID()
    
    public var day: String
    public var studyTime: Int
    
    public init(day: String, studyTime: Int) {
        self.day = day
        self.studyTime = studyTime
    }
}
