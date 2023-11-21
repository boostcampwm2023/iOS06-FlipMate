//
//  NetworkError.swift
//  FlipMate
//
//  Created by 권승용 on 11/21/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURLComponents
    
    var errorDescription: String? {
        switch self {
        case .invalidURLComponents: return "URLComponents 초기화 실패."
        }
    }
}
