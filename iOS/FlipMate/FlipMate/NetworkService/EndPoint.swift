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
    
    func makeURLRequest(with token: String?) throws -> URLRequest {
        let url = try makeURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.field)}
        return urlRequest
    }
    
    func makeURL() throws -> URL {
        let fullPath = "\(baseURL)\(path)"
        guard let components = URLComponents(string: fullPath) else { throw NetworkError.invalidURLComponents }
        
        guard let url = components.url else { throw NetworkError.invalidURLComponents }
        return url
    }
}
