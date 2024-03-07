//
//  PieChartDrawManager.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

final public class PieChartDrawManager: ChartDrawProtocol {
    // MARK: - Properties
    private weak var chartView: PieChartView?
    
    // MARK: - init
    public init(chartView: PieChartView) {
        self.chartView = chartView
    }
}

// MARK: - Methods
extension PieChartDrawManager {
    public func drawData() {
        guard let context = UIGraphicsGetCurrentContext(),
              let chartView = chartView,
              let data = chartView.data as? PieChartData,
              let dataSet = data.dataSet as? PieChartDataSet else { return }
        
        let bounds = chartView.bounds
        let totalTime = dataSet.entry.reduce(0) { $0 + $1.yValues }
        
        var startAngle: CGFloat = .zero,
            endAngle: CGFloat = .zero,
            middleAngle: CGFloat = .zero
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        for (index, entry) in dataSet.entry.enumerated() {
            let yValue = entry.yValues
            guard yValue != .zero else { continue }
            let percentage = yValue / totalTime
            startAngle = endAngle
            endAngle = startAngle + percentage
            middleAngle = startAngle + ((endAngle - startAngle) / 2)
            let xPos: CGFloat = cos((middleAngle.toRadian())) * Constant.hypotenuse
            let yPos: CGFloat = sin((middleAngle.toRadian())) * Constant.hypotenuse
            let path = UIBezierPath()
            
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: bounds.width / 2 - Constant.radiusSpacing,
                        startAngle: startAngle.toRadian(),
                        endAngle: endAngle.toRadian(),
                        clockwise: true)
            UIColor(hexString: dataSet.pieColor(at: index))?.set()
            path.fill()
            path.close()
            UIColor(hexString: dataSet.pieLineColor)?.set()
            path.lineWidth = dataSet.pieLineWidth
            path.stroke()
            drawText(context: context,
                     position: CGPoint(x: center.x + xPos - 30, y: center.y + yPos - 10),
                     text: "\(Int(round(percentage * 100)))%",
                     fontSize: dataSet.pieFontSize, width: 60)
            
            drawMiddleCircle()
        }
    }
    
    func drawMiddleCircle() {
        guard let context = UIGraphicsGetCurrentContext(),
              let chartView = chartView,
              let data = chartView.data as? PieChartData,
              let dataSet = data.dataSet as? PieChartDataSet else { return }

        let bounds = chartView.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let middleCircle = UIBezierPath(
            arcCenter: center,
            radius: dataSet.circleRadius,
            startAngle: Constant.middleCircleStartAngle,
            endAngle: Constant.middleCircleEndAngle,
            clockwise: true)
        
        UIColor(hexString: dataSet.circleColor)?.set()
        middleCircle.fill()
        
        drawText(context: context, 
                 position: CGPoint(x: center.x - dataSet.circleRadius, y: center.y - chartView.mainTitleFontSize),
                 text: chartView.mainTitle,
                 fontSize: chartView.mainTitleFontSize,
                 fontColor: "000000FF",
                 width: dataSet.circleRadius * 2)

        drawText(context: context, 
                 position: CGPoint(x: center.x - dataSet.circleRadius, y: center.y + chartView.subTitleFontSize),
                 text: chartView.subTitle,
                 fontSize: chartView.subTitleFontSize,
                 fontColor: "000000FF",
                 width: dataSet.circleRadius * 2)
    }
}

// MARK: - Methods
extension PieChartDrawManager {
    private enum Constant {
        static let radiusSpacing: CGFloat = 30
        static let hypotenuse: CGFloat = 130
        static let middleCircleStartAngle: CGFloat = 0
        static let middleCircleEndAngle: CGFloat = 360 * CGFloat.pi / 180
    }
}

