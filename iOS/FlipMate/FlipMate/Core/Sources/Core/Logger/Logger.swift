//
//  File.swift
//  
//
//  Created by 권승용 on 5/14/24.
//

import OSLog

enum FMConstant {
    static let bundleID = Bundle.main.bundleIdentifier ?? ""
}

public enum FMLogger {
    static let general = Logger(subsystem: FMConstant.bundleID, category: "general")
    static let user = Logger(subsystem: FMConstant.bundleID, category: "user")
    static let device = Logger(subsystem: FMConstant.bundleID, category: "device")
    static let viewLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "viewLifeCycle")
    static let appLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "appLifeCycle")
    static let timer = Logger(subsystem: FMConstant.bundleID, category: "timer")
    static let friend = Logger(subsystem: FMConstant.bundleID, category: "friend")
    static let chart = Logger(subsystem: FMConstant.bundleID, category: "chart")
}
