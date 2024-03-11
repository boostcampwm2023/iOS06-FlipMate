//
//  LineChartView.swift
//  
//
//  Created by 임현규 on 2024/03/09.
//

import Foundation

public class LineChartView: BaseChartView {
    // MARKL - Properties
    public override var data: ChartData? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawManager = LineChartDrawManager(lineChartView: self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    public override func draw(_ rect: CGRect) {
        guard let data = data as? LineChartData,
              !data.isEmpty else {
            super.draw(rect)
            return
        }
        drawManager?.drawData()
    }
}
