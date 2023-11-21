//
//  URLSessionable.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation
import Combine

protocol URLSessionable {
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
}

extension URLSession: URLSessionable {
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
