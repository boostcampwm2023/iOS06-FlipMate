//
//  DonutChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/06.
//

import UIKit

final class DonutChartView: UIView {
    
    // MARK: - Properties
    private let path = UIBezierPath()
    
    private var studyLog: StudyLog? {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
}

private extension DonutChartView {
    func drawDonutChartLayer() {
        guard let studyLog else { return }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let categories = studyLog.category, totalTime = CGFloat(studyLog.totalTime)
        var startAngle: CGFloat = 0.0, endAngle: CGFloat = 0.0
        
        categories.forEach { category in
            let studyTime = CGFloat(category.studyTime ?? 0)
            let percentage = (studyTime / totalTime)
            startAngle = endAngle
            endAngle = startAngle + CGFloat(percentage)
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: bounds.width / 2 - Constant.radiusSpacing,
                        startAngle: startAngle * 2 * CGFloat.pi,
                        endAngle: endAngle * 2 * CGFloat.pi,
                        clockwise: true)
            UIColor(hexString: category.color)?.set()
            path.fill()
            path.close()
            
            UIColor.gray.set()
            path.lineWidth = Constant.lineWidth
            path.stroke()
        }
    }
    
    func drawMiddleCircle() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let middleCircle = UIBezierPath(
            arcCenter: center,
            radius: Constant.middleCircleRadius,
            startAngle: Constant.middleCircleStartAngle,
            endAngle: Constant.middleCircleEndAngle,
            clockwise: true)
        UIColor.systemBackground.set()
        middleCircle.fill()
    }
}

private extension DonutChartView {
    enum Constant {
        static let lineWidth: CGFloat = 3
        static let radiusSpacing: CGFloat = 30
        
        static let middleCircleRadius: CGFloat = 100
        static let middleCircleStartAngle: CGFloat = 0
        static let middleCircleEndAngle: CGFloat = 360 * CGFloat.pi / 180
    }
}
