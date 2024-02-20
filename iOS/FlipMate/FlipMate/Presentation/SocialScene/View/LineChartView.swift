//
//  LineChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/19.
//

import UIKit

final class LineChartView: UIView {
    
    // MARK: - Properties
    private var textLayerArray = [CATextLayer]()

    private var dataSet: [[Int]]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
              let count = dataSet.first?.count,
              let maxPoint = dataSet.flatMap({ $0 }).max() else { return }
        
        let lineWidth = rect.width / CGFloat(count)
        
        for data in dataSet {
            var xPosition = Int(lineWidth) / 2
            var yBottomPosition = rect.maxY - 40
            var isFirstDataPoint = false
            
            let path = UIBezierPath()
            path.lineWidth = 3
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            
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
}
