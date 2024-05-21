//
//  PatchTimeZoneUseCase.swift
//
//
//  Created by 권승용 on 5/20/24.
//

import Foundation

public protocol PatchTimeZoneUseCase {
    func patchTimeZone(date: Date) async throws
}
