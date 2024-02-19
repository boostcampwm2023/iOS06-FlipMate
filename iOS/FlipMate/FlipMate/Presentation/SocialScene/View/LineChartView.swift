//
//  LineChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/19.
//

import UIKit

final class LineChartView: UIView {
    
    // MARK: - Properties
    private var dataSet: [Int]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        
    }
    
    func fetchData(data: [Int]) {
        self.dataSet = data
    }
}

