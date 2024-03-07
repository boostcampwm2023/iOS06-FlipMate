//
//  PieChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

final public class PieChartData: ChartData {
    public var dataSet: ChartDataSet? {
        return self.dataSets.first
    }
    
    override init(dataSets: [ChartDataSet]) {
        super.init(dataSets: dataSets)
    }
    
    public convenience init(dataSet: ChartDataSet) {
        self.init(dataSets: [dataSet])
    }
}
