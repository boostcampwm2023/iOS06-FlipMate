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
    }
}

// MARK: - Methods
extension BaseChartView {
    public func numberOfData() -> Int {
        return data?.dataSet.count ?? -1
    }
}
