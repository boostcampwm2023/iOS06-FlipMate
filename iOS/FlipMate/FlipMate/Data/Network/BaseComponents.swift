//
//  BaseURL.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/22.
//

import Foundation

enum BaseURL {
    static let flipmateDomain = "https://flipmate.site:3333"
    static let developDomain = "https://flipmate.site:3333"
}

enum Paths {
    static let categories = "/categories"
    static let googleApp = "/auth/google/app"
    static let appleApp = "/auth/apple/app"
    static let studylogs = "/study-logs"
    static let auth = "/auth"
    static let authInfo = "/auth/info"
    static let nickNameValidation = "/user/nickname-validation"
    static let friend = "/mates"
    static let user = "/user"
    static let ping = "/heartbeat"
}
