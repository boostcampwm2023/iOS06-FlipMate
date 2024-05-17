//
//  ChartSegmentedControl.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import UIKit
import DesignSystem

final class ChartSegmentedControl: UISegmentedControl {
    private lazy var segmentView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = FlipMateColor.darkBlue.color
        self.addSubview(view)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSegmentUI()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setSegmentUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    private func setSegmentUI() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var linePosition: CGFloat
        if selectedSegmentIndex == 0 {
            linePosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        } else {
            linePosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex) + 5
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.segmentView.frame.origin.x = linePosition
            }
        )
    }
}
