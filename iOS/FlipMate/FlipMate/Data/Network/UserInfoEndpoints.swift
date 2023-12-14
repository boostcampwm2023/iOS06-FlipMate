//
//  UserInfoEndpoints.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/13.
//

import Foundation

struct UserInfoEndpoints {
    static func userInfo() -> EndPoint<UserInfoResponseDTO> {
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.authInfo,
            method: .get)
    }
    
    static func patchTimeZone(with timeZoneRequestDTO: TimeZoneRequestDTO) -> EndPoint<StatusResponseDTO> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(timeZoneRequestDTO)
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.auth + "/timezone",
            method: .patch,
            data: data)
    }
}
