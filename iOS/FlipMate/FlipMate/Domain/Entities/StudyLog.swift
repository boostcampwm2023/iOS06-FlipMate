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

struct StudyChart {
    var studyLog: [StudyLog]
    var percentage: Int
}
