//
//  SetupProfileInfoUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol SetupProfileInfoUseCase {
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo
}
