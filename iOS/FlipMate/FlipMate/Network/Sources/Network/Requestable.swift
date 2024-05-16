//
//  Requestable.swift
//  
//
//  Created by 권승용 on 5/15/24.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var data: Data? { get }
    var headers: [HTTPHeader]? { get }
    func makeURLRequest(with token: String?) throws -> URLRequest
}
