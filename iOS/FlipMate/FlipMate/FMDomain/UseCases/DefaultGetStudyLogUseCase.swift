//
//  DefaultUserInfoUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Core
import Foundation
import Combine

final class DefaultGetStudyLogUseCase: GetStudyLogUseCase {
    private let repository: StudyLogRepository
    
    init(studyLogRepository: StudyLogRepository) {
        self.repository = studyLogRepository
    }
    
    func getStudyLog() -> AnyPublisher<StudyLog, NetworkError> {
        return repository.getUserInfo()
    }
}
