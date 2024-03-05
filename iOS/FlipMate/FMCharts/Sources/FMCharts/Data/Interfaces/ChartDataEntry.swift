//
//  ChartDataEntry.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public class ChartDataEntry {
    // MARK: - Properties
    public var xValues: [Double]
    public var yValues: [Double]
    
    public var isEmpty: Bool {
        return yValues.isEmpty
    }
    
    public var count: Int {
        return yValues.count
    }
    
    // MARK: - init
    public init(xValues: [Double], yValues: [Double]) {
        self.xValues = xValues
        self.yValues = yValues
    }
}

// MARK: - Methods
extension ChartDataEntry {
    public func max() -> Double {
        return yValues.max() ?? 0.0
    }
}
