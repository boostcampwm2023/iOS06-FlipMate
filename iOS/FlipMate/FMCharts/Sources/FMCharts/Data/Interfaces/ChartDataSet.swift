//
//  ChartDataSet.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public class ChartDataSet {
    // MARK: - Properties
    public var entry: [ChartDataEntry]
    
    public var isEmpty: Bool {
        return entry.isEmpty
    }
    
    public var count: Int {
        return entry.count
    }
    
    // MARK: - init
    public init(entry: [ChartDataEntry]) {
        self.entry = entry
    }
}

// MARK: - Methods
extension ChartDataSet {
    func max() -> Double {
        return entry.map { $0.yValues }.max() ?? 0.0
    }
}
