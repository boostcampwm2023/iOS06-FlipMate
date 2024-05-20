//
//  StudyLogUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Core
import Foundation
import Combine

protocol GetStudyLogUseCase {
    func getStudyLog() -> AnyPublisher<StudyLog, NetworkError>
}
