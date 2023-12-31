//
//  TimeZoneUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/13.
//

import Foundation

protocol PatchTimeZoneUseCase {
    func patchTimeZone(date: Date) async throws
}
