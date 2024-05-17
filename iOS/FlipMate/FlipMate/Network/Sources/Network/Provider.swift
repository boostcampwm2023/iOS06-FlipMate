//
//  Provider.swift
//  
//
//  Created by 권승용 on 5/16/24.
//

import Foundation
import Core
import Combine

public protocol Providable {
    func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError>
    func request<E: RequestResponseable>(with endpoint: E) async throws -> E.Response
}

public struct Provider: Providable {
    private var urlSession: URLSessionable
    private var keychainManager: KeychainManageable
    
    init(urlSession: URLSessionable, keychainManager: KeychainManageable) {
        self.urlSession = urlSession
        self.keychainManager = keychainManager
    }
    
    public func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        do {
            let token = try? keychainManager.getAccessToken()
            let urlReqeust = try endpoint.makeURLRequest(with: token)
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
    
    public func request<E: RequestResponseable>(with endpoint: E) async throws -> E.Response where E: Requestable, E: Responsable {
        let token = try? keychainManager.getAccessToken()
        let urlRequest = try endpoint.makeURLRequest(with: token)
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
