//
//  DonutChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/06.
//

import UIKit

final class DonutChartView: UIView {
    
    // MARK: - Properties
    private var studyLog: StudyLog? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var pathArray = [UIBezierPath]()
    private var textLayerArray = [CATextLayer]()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyBoard")
    }

    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        drawDonutChartLayer()
        drawMiddleCircle()
    }
    
    func fetchStudyLog(_ studyLog: StudyLog) {
        self.studyLog = studyLog
    }
}

// MARK: - Chart Layer funcs
private extension DonutChartView {
    func drawDonutChartLayer() {
        guard let studyLog, studyLog.totalTime != 0 else {
            pathArray.forEach { $0.removeAllPoints() }
            return
        }
        
        textLayerArray.forEach { $0.removeFromSuperlayer() }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let categories = studyLog.category, totalTime = CGFloat(studyLog.totalTime)
        var startAngle: CGFloat = 0.0, endAngle: CGFloat = 0.0, middleAngle: CGFloat = 0.0
        
        for category in categories {
            guard let studyTime = category.studyTime, studyTime != 0 else { continue }
            let percentage = (CGFloat(studyTime) / totalTime)
            startAngle = endAngle
            endAngle = startAngle + CGFloat(percentage)
            middleAngle = startAngle + ((endAngle - startAngle) / 2)
            
            let xPos: CGFloat = cos((middleAngle.toRadian())) * Constant.hypotenuse
            let yPos: CGFloat = sin((middleAngle.toRadian())) * Constant.hypotenuse
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: center.x + xPos, y: center.y + yPos, width: 0, height: 0).insetBy(dx: -60, dy: -7.5)
            textLayer.foregroundColor = FlipMateColor.gray5.color?.cgColor
            textLayer.string = "\(Int(round(percentage * 100)))%"
            textLayer.alignmentMode = .center
            textLayer.fontSize = Constant.chartTextFontSize
            textLayer.font = Constant.chartTextFont as CFTypeRef
            textLayer.isWrapped = true
            layer.addSublayer(textLayer)
            textLayerArray.append(textLayer)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: bounds.width / 2 - Constant.radiusSpacing,
                        startAngle: startAngle.toRadian(),
                        endAngle: endAngle.toRadian(),
                        clockwise: true)
            UIColor(hexString: category.color)?.set()
            path.fill()
            path.close()
            FlipMateColor.gray5.color?.set()
            path.lineWidth = Constant.lineWidth
            path.stroke()
            pathArray.append(path)
        }
    }
    
    func drawMiddleCircle() {
        guard let studyLog, studyLog.totalTime != 0 else {
            textLayerArray.forEach { $0.removeFromSuperlayer() }
            pathArray.forEach { $0.removeAllPoints() }
            drawNoResultText()
            return
        }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let totalTimeLayer = CATextLayer()
        totalTimeLayer.frame = CGRect(x: center.x, y: center.y, width: 0, height: 0).insetBy(dx: -60, dy: -40)
        totalTimeLayer.foregroundColor = UIColor.black.cgColor
        totalTimeLayer.alignmentMode = .center
        totalTimeLayer.fontSize = Constant.totalTimeTextFontSize
        totalTimeLayer.font = Constant.systemTextFont as CFTypeRef
        totalTimeLayer.string = Constant.totalTimeText
        totalTimeLayer.isWrapped = true

        let timeLayer = CATextLayer()
        timeLayer.frame = CGRect(x: center.x, y: center.y + 20, width: 0, height: 0).insetBy(dx: -60, dy: -20)
        timeLayer.foregroundColor = UIColor.black.cgColor
        timeLayer.alignmentMode = .center
        timeLayer.fontSize = Constant.timeTextFontSize
        timeLayer.font = Constant.systemTextFont as CFTypeRef
        timeLayer.string = studyLog.totalTime.secondsToStringTime()
        timeLayer.isWrapped = true
        
        [ totalTimeLayer, timeLayer ] .forEach {
            layer.addSublayer($0)
            textLayerArray.append($0)
        }
        
        let middleCircle = UIBezierPath(
            arcCenter: center,
            radius: Constant.middleCircleRadius,
            startAngle: Constant.middleCircleStartAngle,
            endAngle: Constant.middleCircleEndAngle,
            clockwise: true)
        
        FlipMateColor.gray5.color?.set()
        middleCircle.fill()
        
        pathArray.append(middleCircle)
    }
    
    func drawNoResultText() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let totalTimeLayer = CATextLayer()
        totalTimeLayer.frame = CGRect(x: center.x, y: center.y, width: 0, height: 0).insetBy(dx: -150, dy: -50)
        totalTimeLayer.foregroundColor = UIColor.black.cgColor
        totalTimeLayer.alignmentMode = .center
        totalTimeLayer.fontSize = Constant.noResultTextFontSize
        totalTimeLayer.font = Constant.systemTextFont as CFTypeRef
        totalTimeLayer.string = Constant.noResultText
        totalTimeLayer.isWrapped = true
        layer.addSublayer(totalTimeLayer)
        textLayerArray.append(totalTimeLayer)
    }
}

private extension DonutChartView {
    enum Constant {
        static let lineWidth: CGFloat = 3
        static let radiusSpacing: CGFloat = 30
        
        static let chartTextFont = "AvenirNext-Bold"
        static let systemTextFont = "System-Bold"
        static let chartTextFontSize: CGFloat = 15
        static let totalTimeTextFontSize: CGFloat = 20
        static let timeTextFontSize: CGFloat = 30
        static let noResultTextFontSize: CGFloat = 20
        static let totalTimeText = NSLocalizedString("totalTime", comment: "")
        static let noResultText = NSLocalizedString("noStudyLog", comment: "")
        static let hypotenuse: CGFloat = 130
        
        static let middleCircleRadius: CGFloat = 100
        static let middleCircleStartAngle: CGFloat = 0
        static let middleCircleEndAngle: CGFloat = 360 * CGFloat.pi / 180
    }
}
