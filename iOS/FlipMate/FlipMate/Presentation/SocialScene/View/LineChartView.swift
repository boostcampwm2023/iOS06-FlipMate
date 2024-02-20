//
//  LineChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/19.
//

import UIKit

final class LineChartView: UIView {
    
    // MARK: - Properties
    private var dataSet: [[Int]]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var dataCount: Int {
        return dataSet?.first?.count ?? 0
    }
    
    private var textLayerArray = [CATextLayer]()
    private var xAxisValues: [String] = []
    private lazy var dataColorSet: [UIColor] = Array(repeating: UIColor.red, count: dataCount)
    
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
    
    func drawLineChart(_ rect: CGRect) {
        guard let dataSet,
              let maxPoint = dataSet.flatMap({ $0 }).max() else { return }
        
        let lineWidth = rect.width / CGFloat(dataCount)
        
        for (dataIndex, data) in dataSet.enumerated() {
            var xPosition = Int(lineWidth) / 2
            var yBottomPosition = rect.maxY - 40
            var isFirstDataPoint = false
            
            let path = UIBezierPath()
            path.lineWidth = 3
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            dataColorSet[dataIndex].set()
            
            for dataPoint in data {
                var lineHeight = CGFloat(dataPoint) / CGFloat(maxPoint) * (frame.height - 50)
                var yPosition = Int(yBottomPosition) - Int(lineHeight)
                if lineHeight.isNaN { lineHeight = 0.0 }
                if !isFirstDataPoint {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                    isFirstDataPoint.toggle()
                    continue
                }
                xPosition += Int(lineWidth)
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                path.stroke()
            }
        }
    }
    
    func addTextLayer(position: CGPoint, text: String, width: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: 0, width: width, height: Constant.chartTextFontSize)
        textLayer.position = CGPoint(x: position.x + width / 2, y: position.y - 20)
        textLayer.foregroundColor = FlipMateColor.gray5.color?.cgColor
        textLayer.string = text
        textLayer.alignmentMode = .center
        textLayer.fontSize = Constant.chartTextFontSize
        textLayer.font = Constant.chartTextFont as CFTypeRef
        textLayer.isWrapped = true
        layer.addSublayer(textLayer)
        textLayerArray.append(textLayer)
    }
    
    func fetchData(data: [[Int]]) {
        self.dataSet = data
    }
    
    func lineColor(at index: Int, color: UIColor) {
        guard (0..<dataColorSet.count).contains(index) else { return }
        dataColorSet[index] = color
    }
    
    func updateXAxisValue(values: [String]) {
        xAxisValues = values
        let width = frame.width / CGFloat(values.count)
        for (index, value) in values.enumerated() {
            addTextLayer(position: CGPoint(x: CGFloat(index) * width, y: frame.height), text: value, width: width)
        }
    }
}

private extension LineChartView {
    enum Constant {
        static let chartTextFont = "AvenirNext-Bold"
        static let chartTextFontSize: CGFloat = 15
    }
}
