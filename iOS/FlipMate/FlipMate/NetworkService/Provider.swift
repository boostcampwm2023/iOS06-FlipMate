//
//  Provider.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/21.
//

import Core
import Foundation
import Combine

protocol Providable {
    func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError>
    func request<E: RequestResponseable>(with endpoint: E) async throws -> E.Response
}

struct Provider: Providable {
    private let jsonDecoder = JSONDecoder()
    private var urlSession: URLSessionable
    private let signOutManager: SignOutManageable
    private let keychainManager: KeychainManageable
    
    init(urlSession: URLSessionable,
         signOutManager: SignOutManageable,
         keychainManager: KeychainManageable) {
        self.urlSession = urlSession
        self.signOutManager = signOutManager
        self.keychainManager = keychainManager
    }
    
    func request<E: RequestResponseable>(with endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        do {
            let token = try? keychainManager.getAccessToken()
            let urlReqeust = try endpoint.makeURLRequest(with: token)
            
            return urlSession.response(for: urlReqeust)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    
                    guard 200..<300 ~= response.statusCode else {
                        if response.statusCode == 401 {
                            FMLogger.general.error("토큰이 만료되어 로그인 화면으로 이동합니다.")
                            signOutManager.signOut()
                        }
                        
                        let errorResult = try JSONDecoder().decode(StatusResponseWithErrorDTO.self, from: data)
                        FMLogger.general.error("에러 코드 : \(errorResult.statusCode)\n내용 : \(errorResult.message)")
                        throw configureAPIError(with: errorResult)
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
        let token = try? keychainManager.getAccessToken()
        let urlRequest = try endpoint.makeURLRequest(with: token)
        let (data, response) = try await urlSession.response(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            do {
                if response.statusCode == 401 {
                    FMLogger.general.error("토큰이 만료되어 로그인 화면으로 이동합니다.")
                    signOutManager.signOut()
                }
                
                let errorResult = try JSONDecoder().decode(StatusResponseWithErrorDTO.self, from: data)
                FMLogger.general.error("에러 코드 : \(errorResult.statusCode)\n내용 : \(errorResult.message)")
                throw configureAPIError(with: errorResult)
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

extension Provider {
    func configureAPIError(with errorResult: StatusResponseWithErrorDTO) -> APIError {
        switch errorResult.statusCode {
            // 카테고리 이름 중복
        case 400:
            return .duplicatedCategoryName
            // 닉네임 중복
        case 40000:
            return .duplicatedNickName
            // 이미지 유해함
        case 40001:
            return .imageNotSafe
        default:
            return .unknown
        }
    }
}
