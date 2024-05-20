//
//  DefaultGetStudyLogUseCase.swift
//  
//
//  Created by 권승용 on 5/21/24.
//

import Foundation
import Combine

import Core

public final class DefaultGetStudyLogUseCase: GetStudyLogUseCase {
    private let repository: StudyLogRepository
    
    public init(studyLogRepository: StudyLogRepository) {
        self.repository = studyLogRepository
    }
    
    public func getStudyLog() -> AnyPublisher<StudyLog, NetworkError> {
        return repository.getUserInfo()
    }
}
