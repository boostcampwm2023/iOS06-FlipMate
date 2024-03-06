//
//  PieChartView.swift
//
//
//  Created by 임현규 on 2024/03/06.
//

import Foundation

public class PieChartView: BaseChartView {
    // MARK: - Properties
    public override var data: ChartData? {
        didSet {
            drawManager?.fetchData(data: data)
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawManager = PieChartDrawManager(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life Cycle
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let data = data, !data.isEmpty else { return }
        drawManager?.draw()
    }
}
