//
//  BarChartDrawManager.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

final public class BarChartDrawManager: ChartDrawProtocol {
    // MARK: - Properties
    private weak var barChartView: BaseChartView?

    // MARK: - init
    public init(barChartView: BaseChartView) {
        self.barChartView = barChartView
    }
}

// MKAR: - Methods
extension BarChartDrawManager {
    public func drawData() {
        guard let context = UIGraphicsGetCurrentContext(),
              let barChartView = barChartView,
              let data = barChartView.data as? BarChartData,
              let dataSet = data.dataSet as? BarChartDataSet,
              let color = UIColor(hexString: dataSet.barColor)?.cgColor else { return }
    
        let frame = barChartView.frame
        let maxData = data.max()
        let barWidth = frame.width / CGFloat(data.count) - (dataSet.chartLeftMargin + dataSet.chartRightMargin)
        
        var xPos = dataSet.chartLeftMargin
        
        context.clear(frame)
        context.setFillColor(color)
        
        for entry in dataSet.entry {
            let dataPoint = entry.yValues
            let maxBarHeight = frame.height - dataSet.barTopMargin
            var barHeight = maxBarHeight * (dataPoint / maxData)
            if barHeight.isNaN { barHeight = .zero }
            let yPos = maxBarHeight - barHeight + dataSet.chartTopMargin
            let barRect = CGRect(x: xPos, y: yPos, width: barWidth, height: barHeight)
            context.fill(barRect)
            drawText(context: context, position: CGPoint(x: xPos, y: yPos - dataSet.chartTopMargin), text: "\(entry.yValues)", width: barWidth)
            drawText(context: context, position: CGPoint(x: xPos, y: frame.height - dataSet.textHeight), text: entry.xValues, width: barWidth)
            xPos += barWidth + dataSet.chartLeftMargin + dataSet.chartRightMargin
        }
    }
}
