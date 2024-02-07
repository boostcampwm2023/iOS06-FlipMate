//
//  BarChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/07.
//

import UIKit

final class BarChartView: UIView {
    // MARK: - Properties
    private var dataPoints: [CGFloat]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let dataPoints = dataPoints, let maxPoint = dataPoints.max(),
              let darkBlueColor = FlipMateColor.darkBlue.color?.cgColor else { return }

        context.clear(rect)
        context.setFillColor(darkBlueColor)
        
        let barWidth = rect.width / CGFloat(dataPoints.count) - Constant.xSpacing
        var xPosition = Constant.xPos
        
        for dataPoint in dataPoints {
            let barHeight = (dataPoint / maxPoint) * rect.height
            let barRect = CGRect(x: xPosition, y: rect.height - barHeight, width: barWidth, height: barHeight)
            context.fill(barRect)
            xPosition += barWidth + Constant.xSpacing
        }
    }
    
    func fetchData(dataPoints: [CGFloat]) {
        self.dataPoints = dataPoints
    }
}

private extension BarChartView {
    enum Constant {
        static let xPos: CGFloat = 10
        static let xSpacing: CGFloat = 20
    }
}
