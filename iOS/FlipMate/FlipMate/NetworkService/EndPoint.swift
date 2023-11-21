//
//  EndPoint.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation

typealias ReqeustResponseable = Responsable & Requestable

final class EndPoint<R: Decodable>: ReqeustResponseable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var bodyParameters: Encodable?
    var headers: [String : String]?
    
    init(baseURL: String, path: String, method: HTTPMethod) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
    }
}
