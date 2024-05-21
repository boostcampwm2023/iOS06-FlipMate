//
//  Category.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public struct Category: Hashable {
    public let id: Int
    public var color: String
    public var subject: String
    public var studyTime: Int?
    
    public init(id: Int, color: String, subject: String, studyTime: Int? = nil) {
        self.id = id
        self.color = color
        self.subject = subject
        self.studyTime = studyTime
    }
}
