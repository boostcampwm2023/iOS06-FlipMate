//
//  ChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

public class ChartData {
    // MARK: - Properties
    var dataSets: [ChartDataSet]
    var label: String = ""
        
    public var isEmpty: Bool {
        return dataSets.isEmpty
    }
    
    public var count: Int {
        return dataSets.count
    }
    
    // MARK: - init
    init(dataSets: [ChartDataSet]) {
        self.dataSets = dataSets
    }
}

// MARK: - Methods
extension ChartData {
    func max() -> Double {
        return dataSets.map { $0.max() }.max() ?? 0.0
    }
}
