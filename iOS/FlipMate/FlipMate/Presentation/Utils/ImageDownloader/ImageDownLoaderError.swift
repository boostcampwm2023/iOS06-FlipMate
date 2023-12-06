//
//  ImageDownLoaderError.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import Foundation

enum ImageDownLoaderError: LocalizedError {
    case invalidURLString
    case unSupportImage
    case statusCodeError
    
    var errorDescription: String? {
        switch self {
        case .invalidURLString: return "형식에 맞지 않는 URL입니다."
        case .unSupportImage: return "지원하지 않는 이미지 형식입니다."
        case .statusCodeError: return "상태 코드 범위 비정상"
        }
    }
}
