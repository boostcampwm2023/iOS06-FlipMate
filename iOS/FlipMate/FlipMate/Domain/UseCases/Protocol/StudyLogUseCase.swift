//
//  StudyLogUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/23.
//

import Foundation
import Combine

protocol StudyLogUseCase {
    func getUserInfo() -> AnyPublisher<StudyLog, NetworkError>
}
