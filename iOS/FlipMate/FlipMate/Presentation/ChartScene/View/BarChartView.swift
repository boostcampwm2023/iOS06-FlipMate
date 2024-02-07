//
//  BarChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/02/07.
//

import UIKit

final class BarChartView: UIView {

    // MARK: - Properties
    private var dataPoints: [Int]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // MARK: - Methods
    func fetchData(dataPoints: [Int]) {
        self.dataPoints = dataPoints
    }
}
