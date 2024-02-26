//
//  LineChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/19.
//

import UIKit

final class LineChartView: UIView {
    
    // MARK: - Properties
    private var dataSet: [[Int]] = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var dataCount: Int {
        return dataSet.first?.count ?? 0
    }
    
    private var textLayerArray = [CATextLayer]()
    private var xAxisValues: [String] = []
    private lazy var dataColorSet: [UIColor] = Array(repeating: UIColor.red, count: Constant.maxLineCount)
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        drawLineChart(rect)
    }
    
    func appendData(data: [Int], color: UIColor, name: String) {
        dataSet.append(data)
        lineColor(at: dataSet.endIndex - 1, color: color)
    }
    
    func updateXAxisValue(values: [String]?) {
        guard let values else { return }
        let width = (frame.width - Constant.xSpacing) / CGFloat(values.count)
        for (index, value) in values.enumerated() {
            let xPos = CGFloat(index) * width + Constant.xSpacing
            let yPos = frame.height
            addTextLayer(position: CGPoint(x: xPos, y: frame.height), text: value, width: width)
        }
    }
}

private extension LineChartView {
    func lineColor(at index: Int, color: UIColor) {
        guard (0..<dataColorSet.count).contains(index) else { return }
        dataColorSet[index] = color
    }
    
    func addTextLayer(position: CGPoint, text: String, width: CGFloat, alignmentMode: CATextLayerAlignmentMode = .center) {
        let textLayer = CATextLayer()
        let xPos = position.x + width / 2
        let yPos = position.y - Constant.bottomSpacing / 2
        textLayer.frame = CGRect(x: 0, y: 0, width: width, height: Constant.chartTextFontSize)
        textLayer.position = CGPoint(x: xPos, y: yPos)
        textLayer.foregroundColor = FlipMateColor.gray5.color?.cgColor
        textLayer.string = text
        textLayer.alignmentMode = alignmentMode
        textLayer.fontSize = Constant.chartTextFontSize
        textLayer.font = Constant.chartTextFont as CFTypeRef
        textLayer.isWrapped = true
        layer.addSublayer(textLayer)
        textLayerArray.append(textLayer)
    }
    
    func drawLineChart(_ rect: CGRect) {
        guard let maxPoint = dataSet.flatMap({ $0 }).max().map({ Int(ceil(Double($0) / 5) * 5) }),
              !dataColorSet.isEmpty else { return }
        let lineWidth = (rect.width - Constant.xSpacing) / CGFloat(dataCount)
        drawDashLine(maxPoint: maxPoint)
        
        for (dataIndex, data) in dataSet.enumerated() {
            var xPosition = Int(lineWidth) / 2
            let yBottomPosition = rect.maxY - Constant.bottomSpacing
            var isFirstDataPoint = false
            
            let path = UIBezierPath()
            path.lineWidth = 3
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            dataColorSet[dataIndex].set()
            
            for dataPoint in data {
                var lineHeight = CGFloat(dataPoint) / CGFloat(maxPoint) * (frame.height - Constant.bottomSpacing)
                let yPosition = Int(yBottomPosition) - Int(lineHeight) + Constant.ySpacing
                if lineHeight.isNaN { lineHeight = 0.0 }
                if !isFirstDataPoint {
                    path.move(to: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition))
                    isFirstDataPoint.toggle()
                    drawDot(xPos: xPosition + Int(Constant.xSpacing), yPos: yPosition, color: dataColorSet[dataIndex])
                    continue
                }
                xPosition += Int(lineWidth)
                path.addLine(to: CGPoint(x: xPosition + Int(Constant.xSpacing), y: yPosition))
                drawDot(xPos: xPosition + Int(Constant.xSpacing), yPos: yPosition, color: dataColorSet[dataIndex])
                path.stroke()
            }
        }
    }
    
    func drawDot(xPos: Int, yPos: Int, color: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.addEllipse(in: CGRect(
            x: xPos - Constant.dotRadius,
            y: yPos - Constant.dotRadius,
            width: Constant.dotRadius * 2,
            height: Constant.dotRadius * 2))
        context.fillPath()
    }
    
    func drawDashLine(maxPoint: Int) {
        let dashPoints = (0...Constant.numberOfDash).map { maxPoint / 5 * $0 }
        let xPosition = 0
        let textWidth: CGFloat = 60
        let yBottomPosition = Int(frame.height - Constant.bottomSpacing)
        
        for (index, point) in dashPoints.enumerated() {
            let path = UIBezierPath()
            let yPosition = yBottomPosition - (Int(frame.height - Constant.bottomSpacing) * index / 5) + Constant.ySpacing
            addTextLayer(position: CGPoint(x: xPosition, y: yPosition + Int(Constant.bottomSpacing) / 2), 
                         text: "\(point)",
                         width: textWidth,
                         alignmentMode: .left)
            path.setLineDash([6, 3], count: 2, phase: 0)
            path.move(to: CGPoint(x: Int(Constant.xSpacing), y: yPosition))
            path.addLine(to: CGPoint(x: frame.width - Constant.rightSpacing, y: CGFloat(yPosition)))
            UIColor.gray2.set()
            path.stroke()
        }
    }
}

private extension LineChartView {
    enum Constant {
        static let maxLineCount = 3
        static let dotRadius = 5
        static let xSpacing: CGFloat = 50
        static let bottomSpacing: CGFloat = 40
        static let rightSpacing: CGFloat = 20
        static let ySpacing = 5
        static let numberOfDash = 5
        static let chartTextFont = "AvenirNext-Bold"
        static let chartTextFontSize: CGFloat = 15
    }
}
