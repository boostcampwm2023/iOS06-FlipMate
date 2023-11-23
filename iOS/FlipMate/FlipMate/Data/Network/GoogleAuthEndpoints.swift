//
//  GoogleLoginEndpoints.swift
//  FlipMate
//
//  Created by 신민규 on 11/23/23.
//

import Foundation

struct GoogleAuthEndpoints {
    static func enterGoogleLogin(_ dto: GoogleAuthRequestDTO) -> EndPoint<GoogleAuthResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(dto)
        return EndPoint(baseURL: BaseURL.developDomain, path: Paths.googleApp, method: .post, data: data)
    }
}
