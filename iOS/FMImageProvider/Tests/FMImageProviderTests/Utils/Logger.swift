//
//  File.swift
//  
//
//  Created by 권승용 on 3/19/24.
//

import Foundation
import OSLog
@testable import FMImageProvider

extension FMLogger {
    static let test = Logger(subsystem: Bundle.main.bundleIdentifier ?? "FMImageProvider", category: "FMImageProviderTests")
}
