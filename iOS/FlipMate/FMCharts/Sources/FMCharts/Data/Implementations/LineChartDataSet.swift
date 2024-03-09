//
//  LineChartDataSet.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public protocol LineChartDataSetProtocol {
    var lineWidth: Double { get }
    var lineColor: String { get }
    var dotWidth: Double { get }
    var dotheight: Double { get }
    var dotColor: String { get }
}

final public class LineChartDataSet: ChartDataSet, LineChartDataSetProtocol {
    public var lineWidth: Double = 3
    public var lineColor: String = .init()
    public var dotWidth: Double = .init()
    public var dotheight: Double = .init()
    public var dotColor: String = .init()
    
    public override init(entry: [ChartDataEntry]) {
        super.init(entry: entry)
    }
}
