//
//  UserInfoStorage.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/01.
//

import Foundation

struct UserInfoStorage {
    @UserDefault(key: "nickname", defaultValue: "")
    static var nickname: String
    @UserDefault(key: "imageData", defaultValue: Data.init())
    static var imageData: Data?
}