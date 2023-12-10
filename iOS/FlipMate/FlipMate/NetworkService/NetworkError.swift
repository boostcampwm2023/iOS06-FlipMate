//
//  NetworkError.swift
//  FlipMate
//
//  Created by 권승용 on 11/21/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURLComponents
    case invalidResponse
    case statusCodeError(statusCode: Int, message: String)
    case bodyEmpty
    case typeCastingFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURLComponents: return "URLComponents 초기화 실패."
        case .invalidResponse: return "Response 타입 HTTPURLResponse로 변환 실패"
        case .statusCodeError(_, let message): return message
        case .bodyEmpty: return "Response body가 비어있음"
        case .typeCastingFailed: return "형변환 실패"
        case .unknown: return "알 수 없는 에러"
        }
    }
}
