//
//  BarChartView.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

public class BarChartView: BaseChartView {
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
        drawManager = BarChartDrawManager(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life cycle
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let data = data, !data.entry.isEmpty else { return }
        drawManager?.draw()
    }
}
