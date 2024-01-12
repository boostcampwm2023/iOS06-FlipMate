//
//  Requestable.swift
//  FlipMate
//
//  Created by 권승용 on 11/21/23.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var data: Data? { get }
    var headers: [HTTPHeader]? { get }
    func makeURLRequest(with token: String?) throws -> URLRequest
    func makeURL() throws -> URL
}
