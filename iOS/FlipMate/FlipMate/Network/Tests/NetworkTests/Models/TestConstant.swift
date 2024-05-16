//
//  TestConstant.swift
//
//
//  Created by 권승용 on 5/16/24.
//

import Foundation

enum TestConstant {
    static let url = URL(string:"https://example.com")!
    static let dummyData = TestCodableType(title: "title", body: "body")
    static let token = "token"
    static let path = "path"
}

struct TestCodableType: Codable, Equatable {
    let title: String
    let body: String
}
