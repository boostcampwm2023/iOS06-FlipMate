//
//  Provider.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Foundation
import Combine

protocol Providable {
    func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError>
    func request<E: RequestResponseable>(with endpoint: E) async throws -> E.Response
}

struct Provider: Providable {
    private let jsonDecoder = JSONDecoder()
    private var urlSession: URLSessionable
    private let signOutManager: SignOutManagerProtocol?
    
    init(urlSession: URLSessionable, signOutManager: SignOutManagerProtocol? = nil) {
        self.urlSession = urlSession
        self.signOutManager = signOutManager
    }
    
    func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        do {
            let urlReqeust = try endpoint.makeURLRequest()
            return urlSession.response(for: urlReqeust)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    
                    guard 200..<300 ~= response.statusCode else {
                        if response.statusCode == 401 {
                            FMLogger.general.error("토큰이 만료되어 로그인 화면으로 이동합니다.")
                            signOutManager?.signOut()
                        }
                        
                        let errorResult = try JSONDecoder().decode(StatusResponseWithErrorDTO.self, from: data)
                        FMLogger.general.error("에러 코드 : \(errorResult.statusCode)\n내용 : \(errorResult.message)")
                        throw NetworkError.statusCodeError(statusCode: response.statusCode, message: errorResult.message)
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
    
    func request<E: RequestResponseable>(with endpoint: E) async throws -> E.Response where E: Requestable, E: Responsable {
        let urlRequest = try endpoint.makeURLRequest()
        let (data, response) = try await urlSession.response(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            do {
                if response.statusCode == 401 {
                    FMLogger.general.error("토큰이 만료되어 로그인 화면으로 이동합니다.")
                    signOutManager?.signOut()
                }
                
                let errorResult = try JSONDecoder().decode(StatusResponseWithErrorDTO.self, from: data)
                FMLogger.general.error("에러 코드 : \(errorResult.statusCode)\n내용 : \(errorResult.message)")
                throw APIError.errorResponse(errorResult)
            } catch let error as APIError {
                throw error
            } catch {
                FMLogger.general.error("에러 코드 : \(response.statusCode)\n내용 : \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                throw NetworkError.statusCodeError(
                    statusCode: response.statusCode,
                    message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
            }
        }
        
        guard !data.isEmpty else {
            throw NetworkError.bodyEmpty
        }
        
        let decoder = JSONDecoder()
        let responseData = try decoder.decode(E.Response.self, from: data)
        return responseData
    }
}

enum APIError: Error {
    case errorResponse(StatusResponseWithErrorDTO)
}
