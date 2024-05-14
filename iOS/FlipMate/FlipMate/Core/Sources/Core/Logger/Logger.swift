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
    public static let general = Logger(subsystem: FMConstant.bundleID, category: "general")
    public static let user = Logger(subsystem: FMConstant.bundleID, category: "user")
    public static let device = Logger(subsystem: FMConstant.bundleID, category: "device")
    public static let viewLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "viewLifeCycle")
    public static let appLifeCycle = Logger(subsystem: FMConstant.bundleID, category: "appLifeCycle")
    public static let timer = Logger(subsystem: FMConstant.bundleID, category: "timer")
    public static let friend = Logger(subsystem: FMConstant.bundleID, category: "friend")
    public static let chart = Logger(subsystem: FMConstant.bundleID, category: "chart")
}
