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
    var headers: [String: String]? { get }
}

extension Requestable {
    func makeURLRequest() throws -> URLRequest {
        let url = try makeURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = data
        headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0)}
        return urlRequest
    }

    func makeURL() throws -> URL {
        let fullPath = "\(baseURL)\(path)"
        guard var components = URLComponents(string: fullPath) else { throw NetworkError.invalidURLComponents }
        
        guard let url = components.url else { throw NetworkError.invalidURLComponents }
        return url
    }
}

