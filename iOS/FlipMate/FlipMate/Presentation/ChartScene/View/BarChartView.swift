//
//  BarChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/07.
//

import UIKit

final class BarChartView: UIView {
    // MARK: - Properties
    private var dailyDatas: [DailyData]? {
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
        drawBarChart()
    }
    
    func fetchData(dailyDatas: [DailyData]) {
        self.dailyDatas = dailyDatas
    }
}

private extension BarChartView {
    func drawBarChart() {
        guard let context = UIGraphicsGetCurrentContext(),
              let dailyDatas = dailyDatas, let maxPoint = dailyDatas.map({ $0.studyTime }).max(),
              let darkBlueColor = FlipMateColor.darkBlue.color?.cgColor else { return }

        context.clear(frame)
        context.setFillColor(darkBlueColor)
        
        let barWidth = frame.width / CGFloat(dailyDatas.count) - Constant.xSpacing
        var xPosition = Constant.xPos
        
        for dailyData in dailyDatas {
            let dataPoint = CGFloat(dailyData.studyTime)
            let barHeight = (dataPoint / CGFloat(maxPoint)) * frame.height
            let yPosition = frame.height - barHeight
            let barRect = CGRect(x: xPosition, y: yPosition, width: barWidth, height: barHeight)
            context.fill(barRect)
            drawStudyTimeText(xPos: xPosition, yPos: yPosition, point: dataPoint, width: barWidth)
            xPosition += barWidth + Constant.xSpacing
        }
    }
    
    func drawStudyTimeText(xPos: CGFloat, yPos: CGFloat, point: CGFloat, width: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: 0, width: width, height: Constant.chartTextFontSize)
        textLayer.position = CGPoint(x: xPos + width / 2, y: yPos - 20)
        textLayer.foregroundColor = FlipMateColor.gray5.color?.cgColor
        textLayer.string = "\(Int(point))"
        textLayer.alignmentMode = .center
        textLayer.fontSize = Constant.chartTextFontSize
        textLayer.font = Constant.chartTextFont as CFTypeRef
        textLayer.isWrapped = true
        layer.addSublayer(textLayer)
    }
}

private extension BarChartView {
    enum Constant {
        static let xPos: CGFloat = 10
        static let xSpacing: CGFloat = 20
        static let chartTextFont = "AvenirNext-Bold"
        static let chartTextFontSize: CGFloat = 15
    }
}
