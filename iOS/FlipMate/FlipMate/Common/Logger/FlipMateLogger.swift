//
//  FlipMateLogger.swift
//  FlipMate
//
//  Created by 권승용 on 11/16/23.
//

import Foundation
import OSLog

enum FMLogger {
    static let general = Logger(subsystem: FMConstant.bundleID, category: "general")
    static let user = Logger(subsystem: FMConstant.bundleID, category: "user")
    static let device = Logger(subsystem: FMConstant.bundleID, category: "device")
    static let viewLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "viewLifeCycle")
    static let appLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "appLifeCycle")
}
