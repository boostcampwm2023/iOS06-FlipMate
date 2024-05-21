//
//  SocialChart.swift
//
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct SocialChart {
    public let myData: [Int]
    public let friendData: [Int]
    public let primaryCategory: String?
    
    public init(myData: [Int], friendData: [Int], primaryCategory: String?) {
        self.myData = myData
        self.friendData = friendData
        self.primaryCategory = primaryCategory
    }
}

// MARK: - Components of Chart
public struct StudyTime: Identifiable {
    public var id: UUID = UUID()
    
    public let weekday: Date
    public let studyTime: Int
    
    public init(id: UUID, weekday: Date, studyTime: Int) {
        self.id = id
        self.weekday = weekday
        self.studyTime = studyTime
    }
}

public struct Series: Identifiable {
    public let id: UUID = UUID()
    
    public let isMySeries: Bool
    public let user: String
    public let studyTime: [Int]
    public let weekdays: [Date]
    public let hexString: String
    
    public init(isMySeries: Bool, user: String, studyTime: [Int], weekdays: [Date], hexString: String) {
        self.isMySeries = isMySeries
        self.user = user
        self.studyTime = studyTime
        self.weekdays = weekdays
        self.hexString = hexString
    }
}
