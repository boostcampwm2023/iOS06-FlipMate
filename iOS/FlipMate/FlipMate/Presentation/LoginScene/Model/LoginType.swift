//
//  LoginType.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

enum LoginType {
    case google
    case apple
    
    var description: String {
        switch self {
        case .google:
            "구글 계정으로 로그인"
        case .apple:
            "애플 계정으로 로그인"
        }
    }
    
    // TODO: - 이미지 Assets 추가 후 작업
    var logoImage: String {
        switch self {
        case .google:
            ""
        case .apple:
            ""
        }
    }
}
