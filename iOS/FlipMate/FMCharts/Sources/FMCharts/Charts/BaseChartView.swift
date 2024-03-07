//
//  BaseChartView.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

public class BaseChartView: UIView {
    // MARK: - Properties
    public var data: ChartData?
    public var drawManager: ChartDrawProtocol?
    public var noDataText: String = ""
    public var noDataFontSize: CGFloat = 20
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life Cycle
    public override func draw(_ rect: CGRect) {
        // MARK: - 공통으로 결과 없을 떄 Text 그리기
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawManager?.drawText(
            context: context,
            position: CGPoint(x: bounds.midX - (frame.width / 2), y: bounds.midY),
            text: noDataText,
            fontSize: noDataFontSize,
            fontColor: "000000FF",
            width: frame.width)
        
    }
}

// MARK: - Methods
extension BaseChartView {
    public func numberOfData() -> Int {
        return data?.count ?? -1
    }
}
