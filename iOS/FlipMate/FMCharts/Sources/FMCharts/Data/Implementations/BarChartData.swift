//
//  BarChartData.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

final public class BarChartData: ChartData {
    public override var count: Int {
        return dataSet?.count ?? 0
    }
    
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
