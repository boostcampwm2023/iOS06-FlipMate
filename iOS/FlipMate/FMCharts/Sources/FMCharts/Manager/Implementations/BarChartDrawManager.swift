//
//  BarChartDrawManager.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

final public class BarChartDrawManager: ChartDrawProtocol {
    // MARK: - Properties
    private var frame: CGRect?
    private var data: ChartData?

    // MARK: - init
    public init(frame: CGRect) {
        self.frame = frame
    }
}

// MKAR: - Methods
extension BarChartDrawManager {
    public func fetchData(data: ChartData?) {
        self.data = data
    }
    
    public func draw() {
        guard let context = UIGraphicsGetCurrentContext(),
              let frame = frame,
              let data = data else {
            return
        }
        
        let color = UIColor.blue.cgColor
        let maxData = data.max()
        let barWidth = frame.width / CGFloat(data.count) - (Constant.leftMargin + Constant.rightMargin)
        var xPos = Constant.leftMargin
        
        context.clear(frame)
        context.setFillColor(color)
        
        for entry in data.dataSet.entry {
            let dataPoint = entry.yValues
            let maxBarHeight = frame.height - Constant.barMargin
            var barHeight = maxBarHeight * (dataPoint / maxData)
            if barHeight.isNaN { barHeight = .zero }
            let yPos = maxBarHeight - barHeight + Constant.topMargin
            let barRect = CGRect(x: xPos, y: yPos, width: barWidth, height: barHeight)
            context.fill(barRect)
            drawText(context: context, position: CGPoint(x: xPos, y: yPos - Constant.topMargin), text: "\(entry.yValues)", width: barWidth)
            drawText(context: context, position: CGPoint(x: xPos, y: frame.height - 20), text: entry.xValues, width: barWidth)
            xPos += barWidth + Constant.leftMargin + Constant.rightMargin
        }
    }
}

// MARK: - Constant
extension BarChartDrawManager {
    private enum Constant {
        static let barMargin: CGFloat = 60
        static let topMargin: CGFloat = 30
        static let leftMargin: CGFloat = 10
        static let rightMargin: CGFloat = 10
        static let textHeight: CGFloat = 20
    }
}
