//
//  SignUpRepository.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

protocol ProfileSettingsRepository {
    func checkIfNickNameIsDuplicated(_ nickName: String) async throws -> Bool
    func setupNewProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo
}
