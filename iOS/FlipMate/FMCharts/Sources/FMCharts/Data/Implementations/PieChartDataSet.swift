//
//  PieChartDataSet.swift
//
//
//  Created by 임현규 on 2024/03/05.
//

import Foundation

public protocol PieChartDataSetProtocol {
    var pieColors: [String] { get }
    var pieLineWidth: Double { get }
    var pieLineColor: String { get }
    var circleRadius: Double { get }
    var circleColor: String { get }
    var pieFontSize: Double { get }

    func pieColor(at index: Int) -> String
}

final public class PieChartDataSet: ChartDataSet, PieChartDataSetProtocol {
    public var pieColors: [String] = []
    public var circleRadius: Double = 100
    public var circleColor: String = "C5C5C6FF"
    public var pieLineColor: String = "C5C5C6FF"
    public var pieLineWidth: Double = 3
    public var pieFontSize: Double = 20
    
    public override init(entry: [ChartDataEntry]) {
        super.init(entry: entry)
    }
    
    public func pieColor(at index: Int) -> String {
        guard (0..<pieColors.count).contains(index) else { return "000000F" }
        return self.pieColors[index]
    }
}
