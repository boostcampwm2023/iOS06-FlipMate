//
//  URLSessionable.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation
import Combine

protocol URLSessionable {
    typealias APIResponse = (data: Data, response: URLResponse)
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
    func response(for request: URLRequest) async throws -> APIResponse
}

extension URLSession: URLSessionable {
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
    
    func response(for request: URLRequest) async throws -> APIResponse {
        return try await data(for: request)
    }
}
