//
//  EndPoint.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation

typealias RequestResponseable = Responsable & Requestable

final class EndPoint<R: Decodable>: RequestResponseable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var data: Data?
    var headers: [HTTPHeader]?
    
    init(baseURL: String, path: String, method: HTTPMethod, data: Data? = nil, headers: [HTTPHeader]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.data = data
        self.headers = headers
    }
}
