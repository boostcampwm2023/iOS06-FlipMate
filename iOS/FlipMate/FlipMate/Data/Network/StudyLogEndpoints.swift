//
//  StudyLogEndpoints.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation

struct StudyLogEndpoints {
    static func getStudyLog() -> EndPoint<StudyLogResponseDTO> {
        let encoder = JSONEncoder()
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.studylogs + "?date=\(Date().dateToString(format: .yyyyMMdd))",
            method: .get)
    }
}
