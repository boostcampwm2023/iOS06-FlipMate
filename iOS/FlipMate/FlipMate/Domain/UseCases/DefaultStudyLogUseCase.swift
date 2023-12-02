//
//  DefaultUserInfoUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation
import Combine

final class DefaultStudyLogUseCase: StudyLogUseCase {
    private let userInfoRepository: StudyLogRepository
    
    init(userInfoRepository: StudyLogRepository) {
        self.userInfoRepository = userInfoRepository
    }
    
    func getUserInfo() -> AnyPublisher<StudyLog, NetworkError> {
        return userInfoRepository.getUserInfo()
    }
}
