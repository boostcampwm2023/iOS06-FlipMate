//
//  StduyLogMock.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation

let responseData = """
    {
        "today_time": 11100,
        "categories": [
            {
                "category_id": 1,
                "name": "토익 공부",
                "color": "#1111111",
                "today_time": 100
            },
            {
                "category_id": 2,
                "name": "백준 골드 문제 풀기",
                "color": "#0000000",
                "today_time": 1000
            },
            {
                "category_id": 3,
                "name": "부스트캠프 프로젝트",
                "color": "#2222222",
                "today_time": 10000
            },

        ]
    }
"""

let studyLogMockResponse = MockResponse(
    data: responseData.data(using: .utf8),
    urlResponse: HTTPURLResponse(
        url: URL(string: BaseURL.flipmateDomain)!,
        statusCode: 201,
        httpVersion: nil,
        headerFields: nil),
    error: nil
)
