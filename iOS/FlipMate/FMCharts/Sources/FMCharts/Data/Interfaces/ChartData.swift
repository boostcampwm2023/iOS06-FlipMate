//
//  ChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

public class ChartData {
    // MARK: - Properties
    public var entry: ChartDataEntry
    public var label: String
        
    // MARK: - init
    public init(entry: ChartDataEntry, label: String) {
        self.entry = entry
        self.label = label
    }
}

// MARK: - Methods
extension ChartData {
    func max() -> Double {
        return entry.max()
    }
}
