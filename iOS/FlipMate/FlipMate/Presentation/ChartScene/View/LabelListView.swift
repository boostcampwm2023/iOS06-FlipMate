//
//  LabelListView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/29.
//

import UIKit

final class LabelListView: UIView {
 
    // MARK: - Properties
    private var lineCount: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: lineCount * Constants.spacingY)
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Label Methods
    func addLabel(_ labels: [ChartLabel]) {
        lineCount += 1
        var positionX = Constants.defaultPositionX
        var positionY = Constants.defaultPositionY
        let spacingX = Constants.spacingX
        let spacingY = Constants.spacingY
        
        labels.forEach { label in
            let labelView = LabelView()
            labelView.updateLabel(label: label)
            
            if frame.width - positionX < labelView.widthSize {
                positionX = Constants.defaultPositionX
                positionY += spacingY
                lineCount += 1
            }
            
            labelView.frame = CGRect(x: positionX, y: positionY, width: labelView.widthSize, height: Constants.labelViewHegith)
            addSubview(labelView)
            positionX += labelView.widthSize + spacingX
        }
    }
    
    func removeAllLabel() {
        subviews.forEach { $0.removeFromSuperview() }
        lineCount = 0
    }
}

extension LabelListView {
    // MARK: - Constants
    private enum Constants {
        static let spacingX: CGFloat = 10
        static let spacingY: CGFloat = 25
        static let defaultPositionX: CGFloat = 10
        static let defaultPositionY: CGFloat = 0
        static let labelViewHegith: CGFloat = 20
    }
}
