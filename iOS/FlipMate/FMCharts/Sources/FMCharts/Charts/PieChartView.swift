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
            setNeedsDisplay()
        }
    }
    
    private var _mainTitle = "mainTitle"
    private var _mainTitleFontSize: CGFloat = 30
    private var _subTitle = "subTitle"
    private var _subTitleFontSize: CGFloat = 20

    public var mainTitle: String {
        get {
            return self._mainTitle
        }
        set {
            _mainTitle = newValue
            setNeedsDisplay()
        }
    }
    
    public var mainTitleFontSize: CGFloat {
        get {
            return self._mainTitleFontSize
        }
        set {
            _mainTitleFontSize = newValue
            setNeedsDisplay()
        }
    }
    
    public var subTitle: String {
        get {
            return self._subTitle
        }
        set {
            _subTitle = newValue
            setNeedsDisplay()
        }
    }
    
    public var subTitleFontSize: CGFloat {
        get {
            return self._subTitleFontSize
        }
        set {
            _subTitleFontSize = newValue
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawManager = PieChartDrawManager(chartView: self)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life Cycle
    public override func draw(_ rect: CGRect) {
        guard let data = data as? PieChartData,
              let dataSet = data.dataSet,
              !data.isEmpty,
              dataSet.entry.reduce(0, { $0 + $1.yValues }) != .zero else {
            super.draw(rect)
            return
        }
        drawManager?.drawData()
    }
}
