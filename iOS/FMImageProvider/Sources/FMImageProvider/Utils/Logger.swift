//
//  File.swift
//  
//
//  Created by 권승용 on 3/11/24.
//

import Foundation
import OSLog

enum FMLogger {
    static let general = Logger(subsystem: Bundle.main.bundleIdentifier ?? "FMImageProvider", category: "FMImageProvider")
}
