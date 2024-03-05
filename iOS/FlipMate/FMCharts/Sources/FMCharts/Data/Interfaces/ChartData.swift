//
//  ChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

public class ChartData {
    // MARK: - Properties
    public var dataSet: ChartDataSet
    public var label: String
        
    public var isEmpty: Bool {
        return dataSet.isEmpty
    }
    
    public var count: Int {
        return dataSet.count
    }
    
    // MARK: - init
    public init(dataSet: ChartDataSet, label: String) {
        self.dataSet = dataSet
        self.label = label
    }
}

// MARK: - Methods
extension ChartData {
    func max() -> Double {
        return dataSet.max()
    }
}
