//
//  MockURLSession.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation
import Combine

struct MockResponse {
    let data: Data?
    let urlResponse: URLResponse?
    let error: NetworkError?
}

class MockURLSession: URLSessionable {
    
    let response: MockResponse
    
    init(response: MockResponse) {
        self.response = response
    }
    
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        guard let status = response.urlResponse as? HTTPURLResponse else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let url = request.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: status.statusCode,
            httpVersion: nil,
            headerFields: nil) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let data = response.data else { return Just((data: Data(), response: httpResponse))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
        return Just((data: data, response: httpResponse))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
    func response(for request: URLRequest) async throws -> APIResponse {
        guard let status = response.urlResponse as? HTTPURLResponse else {
            throw URLError(.badURL)
        }
        
        guard let url = request.url else {
            throw NetworkError.invalidURLComponents
        }
        
        guard let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: status.statusCode,
            httpVersion: nil,
            headerFields: nil) else {
            throw NetworkError.invalidResponse
        }
        
        guard let data = response.data else {
            return ((data: Data(), response: httpResponse))
        }
        
        return (data: data, response: httpResponse)
    }
}
