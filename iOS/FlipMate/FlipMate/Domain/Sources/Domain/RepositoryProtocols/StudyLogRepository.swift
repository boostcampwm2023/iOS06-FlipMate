//
//  StudyLogRepository.swift
//  
//
//  Created by 권승용 on 5/18/24.
//

import Foundation

public protocol StudyLogRepository {
    func getUserInfo() -> AnyPublisher<StudyLog, NetworkError>
    func studingPing() async throws
}
