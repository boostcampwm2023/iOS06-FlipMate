//
//  LoginType.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//
import Foundation

enum LoginType {
    case google
    case apple
    
    var buttonTitle: String {
        switch self {
        case .google:
            NSLocalizedString("googleLogin", comment: "")
        case .apple:
            NSLocalizedString("appleLogin", comment: "")
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
