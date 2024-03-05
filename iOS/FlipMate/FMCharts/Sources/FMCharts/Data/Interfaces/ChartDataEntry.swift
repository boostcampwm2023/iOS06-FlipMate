//
//  ChartDataEntry.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public class ChartDataEntry {
    // MARK: - Properties
    public var xValues: String
    public var yValues: Double
    
    // MARK: - init
    public init(xValues: String, yValues: Double) {
        self.xValues = xValues
        self.yValues = yValues
    }
}
