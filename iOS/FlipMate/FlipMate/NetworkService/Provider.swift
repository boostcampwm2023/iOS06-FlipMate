//
//  Provider.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation
import Combine

protocol Providable {
    func request<E: ReqeustResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError>
}

struct Provider: Providable {
    private let jsonDecoder = JSONDecoder()
    private var urlSession: URLSessionable
    
    init(urlSession: URLSessionable) {
        self.urlSession = urlSession
    }
    
    func request<E: ReqeustResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        do {
            let urlReqeust = try endpoint.getUrlRequest()
            return urlSession.response(for: urlReqeust)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidURLComponents }
                    
                    guard 200..<300 ~= response.statusCode else {
                        throw NetworkError.invalidURLComponents
                    }
                    
                    guard !data.isEmpty else {
                        throw NetworkError.invalidURLComponents
                    }
                    
                    return data
                }
                .decode(type: E.Response.self, decoder: jsonDecoder)
                .mapError({ error in
                    if let error = error as? NetworkError {
                        return error
                    } else {
                        return NetworkError.invalidURLComponents
                    }
                })
                .eraseToAnyPublisher()
        } catch let error as NetworkError {
            return Fail(error: error).eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.invalidURLComponents).eraseToAnyPublisher()
        }
    }
}

