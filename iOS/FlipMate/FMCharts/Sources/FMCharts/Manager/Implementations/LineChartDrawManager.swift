//
//  LineChartDrawManager.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

final class LineChartDrawManager: ChartDrawProtocol {
    // MARK: - Properties
    private weak var lineChartView: BaseChartView?
    
    // MARK: - init
    init(lineChartView: BaseChartView) {
        self.lineChartView = lineChartView
    }
    
    func drawData() {
        guard let context = UIGraphicsGetCurrentContext(),
              let lineChartView = lineChartView,
              let data = lineChartView.data else { return }
        let bounds = lineChartView.bounds

        drawData(context: context, rect: bounds, data: data)
        drawXAxis(context: context, frame: bounds, xAxis: data.xAxis)
        drawYAxis(context: context, frame: bounds, data: data)
    }
}

// MARK: - Private Methods
private extension LineChartDrawManager {
    func drawData(context: CGContext, rect: CGRect, data: ChartData) {
        let maxPoint = data.max()
        
        for dataSet in data.dataSets {
            guard let dataSet = dataSet as? LineChartDataSetProtocol else { return }
            drawDataSet(context: context, rect: rect, dataSet: dataSet, maxPoint: Int(maxPoint))
        }
    }
    
    func drawDataSet(context: CGContext, rect: CGRect, dataSet: LineChartDataSetProtocol, maxPoint: Int) {
        let lineWidth = (rect.width - Constant.xSpacing) / Double(dataSet.count)
        var xPosition = Int(lineWidth) / 2
        let yBottomPosition = rect.maxY - Constant.bottomSpacing
        var isFirstDataPoint = false
        
        let path = UIBezierPath()
        path.lineWidth = dataSet.lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        UIColor(hexString: dataSet.lineColor)?.set()
        
        for index in (0..<dataSet.count) {
            guard let entry = dataSet.entryForIndex(at: index) else { return }
            let yValues = entry.yValues
            var lineHeight = yValues / Double(maxPoint) * (rect.height - Constant.bottomSpacing)
            let yPosition = Int(yBottomPosition) - Int(lineHeight) + Constant.ySpacing
            if lineHeight.isNaN { lineHeight = .zero }
            if !isFirstDataPoint {
                path.move(to: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition))
                isFirstDataPoint.toggle()
                drawDot(context: context, pos: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition), dataSet: dataSet)
                continue
            }
            
            xPosition += Int(lineWidth)
            path.addLine(to: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition))
            drawDot(context: context, pos: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition), dataSet: dataSet)
            path.stroke()
        }
    }
    
    func drawDot(context: CGContext, pos: CGPoint, dataSet: LineChartDataSetProtocol) {
        guard let dotColor = UIColor(hexString: dataSet.dotColor) else { return }
        context.setFillColor(dotColor.cgColor)
        context.addEllipse(in: CGRect(
            x: pos.x - dataSet.dotRadius,
            y: pos.y - dataSet.dotRadius,
            width: dataSet.dotRadius * 2,
            height: dataSet.dotRadius * 2))
        context.fillPath()
    }
    
    func drawDashLine(context: CGContext, maxValue: Int, frame: CGRect, numberOfDashLine: Int) {
        let dashPoints = (0...numberOfDashLine).map { maxValue / numberOfDashLine * $0 }
        let yBottomPosition = Int(frame.height - Constant.bottomSpacing)
        
        for index in (0..<dashPoints.count) {
            let path = UIBezierPath()
            let yPosition = yBottomPosition - (Int(frame.height - Constant.bottomSpacing) * index / numberOfDashLine) + Constant.ySpacing
            path.setLineDash([6, 3], count: 2, phase: 0)
            path.move(to: CGPoint(x: Int(Constant.xSpacing), y: yPosition))
            path.addLine(to: CGPoint(x: frame.width - Constant.rightSpacing, y: CGFloat(yPosition)))
            UIColor.gray.set()
            path.stroke()
        }
    }
    
    func drawXAxis(context: CGContext, frame: CGRect, xAxis: XAxis?) {
        guard let values = xAxis?.enties else { return }
        let width = (frame.width - Constant.xSpacing) / CGFloat(values.count)

        for (index, value) in values.enumerated() {
            let xPos = CGFloat(index) * width + Constant.xSpacing
            let yPos = frame.height - Constant.bottomSpacing + 15
            drawText(context: context, position: CGPoint(x: xPos, y: yPos), text: value, width: width)
        }
    }
    
    func drawYAxis(context: CGContext, frame: CGRect, data: ChartData) {
        let maxValue = Int(data.max())
        let dashPoints = (0...5).map { maxValue / 5 * $0 }

        let yBottomPosition = Int(frame.height - Constant.bottomSpacing)

        for (index, value) in dashPoints.enumerated() {
            let xPos = 0
            let yPos = yBottomPosition - (Int(frame.height - Constant.bottomSpacing) * index / (dashPoints.count - 1)) + Constant.ySpacing - 11 / 2
            drawText(context: context,
                     position: CGPoint(x: xPos, y: yPos),
                     text: value.secondsToStringTime(),
                     fontSize: 11,
                     width: 60,
                     alignmentMode: .left
            )
        }
        
        drawDashLine(context: context, maxValue: Int(maxValue), frame: frame, numberOfDashLine: 5)
    }
}

extension LineChartDrawManager {
    private enum Constant {
        static let xSpacing: CGFloat = 50
        static let bottomSpacing: CGFloat = 40
        static let rightSpacing: CGFloat = 20
        static let ySpacing = 5
    }
}
