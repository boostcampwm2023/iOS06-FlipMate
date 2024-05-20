//
//  ProfileSettingsRepository.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public protocol ProfileSettingsRepository {
    func checkIfNickNameIsDuplicated(_ nickName: String) async throws -> Bool
    func setupNewProfileInfo(nickName: String, profileImageData: Data) async throws -> UserInfo
}
