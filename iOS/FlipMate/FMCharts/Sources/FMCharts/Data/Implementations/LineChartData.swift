//
//  LineChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

final public class LineChartData: ChartData {
    override init(dataSets: [ChartDataSet]) {
        super.init(dataSets: dataSets)
    }
    
    public convenience init(dataSets: [ChartDataSet], label: String) {
        self.init(dataSets: dataSets)
        self.label = label
    }
}
