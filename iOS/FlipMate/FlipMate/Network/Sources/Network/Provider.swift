//
//  Provider.swift
//  
//
//  Created by 권승용 on 5/16/24.
//

import Core
import Foundation
import Combine

protocol Providable {
    func request<E: RequestResponseable>(with endpoint: E, using userToken: String) -> AnyPublisher<E.Response, NetworkError>
    func request<E: RequestResponseable>(with endpoint: E, using userToken: String) async throws -> E.Response
}

struct Provider: Providable {
    private var urlSession: URLSessionable
    
    init(urlSession: URLSessionable) {
        self.urlSession = urlSession
    }
    
    func request<E: RequestResponseable>(with endpoint: E, using userToken: String) -> AnyPublisher<E.Response, NetworkError> {
        do {
            let urlReqeust = try endpoint.makeURLRequest(with: userToken)
            let jsonDecoder = JSONDecoder()
            
            return urlSession.response(for: urlReqeust)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    
                    let status = response.statusCode
                    guard 200..<300 ~= status else {
                        let message = String(decoding: data, as: UTF8.self)
                        FMLogger.general.error("에러 코드 : \(response.statusCode)\n내용 : \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                        throw NetworkError.statusCodeError(statusCode: status, message: message)
                    }
                    
                    guard !data.isEmpty else {
                        throw NetworkError.bodyEmpty
                    }
                    
                    return data
                }
                .decode(type: E.Response.self, decoder: jsonDecoder)
                .mapError({ error in
                    if let error = error as? NetworkError {
                        return error
                    } else {
                        return NetworkError.typeCastingFailed
                    }
                })
                .eraseToAnyPublisher()
        } catch let error as NetworkError {
            return Fail(error: error).eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }
    }
    
    func request<E: RequestResponseable>(with endpoint: E, using userToken: String) async throws -> E.Response where E: Requestable, E: Responsable {
        let urlRequest = try endpoint.makeURLRequest(with: userToken)
        let (data, response) = try await urlSession.response(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let status = response.statusCode
        guard 200..<300 ~= status else {
            let message = String(decoding: data, as: UTF8.self)
            FMLogger.general.error("에러 코드 : \(response.statusCode)\n내용 : \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
            throw NetworkError.statusCodeError(statusCode: status, message: message)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.bodyEmpty
        }
        
        let decoder = JSONDecoder()
        let responseData = try decoder.decode(E.Response.self, from: data)
        return responseData
    }
}
