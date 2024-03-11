//
//  LineChartDataSet.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public protocol LineChartDataSetProtocol: ChartDataSetBase {
    var lineWidth: Double { get }
    var lineColor: String { get }
    var dotRadius: Double { get }
    var dotColor: String { get }
    var dashLineColor: String { get }
    var numberOfDashLine: Int { get }
}

final public class LineChartDataSet: ChartDataSet, LineChartDataSetProtocol {
    public var lineWidth: Double = 3
    public var lineColor: String = .init()
    public var dotRadius: Double = .init()
    public var dotColor: String = .init()
    public var dashLineColor: String = .init()
    public var numberOfDashLine: Int = 5
    
    public override init(entry: [ChartDataEntry]) {
        super.init(entry: entry)
    }
}
