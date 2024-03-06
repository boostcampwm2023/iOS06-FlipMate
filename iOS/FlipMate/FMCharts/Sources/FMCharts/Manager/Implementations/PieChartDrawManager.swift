//
//  PieChartDrawManager.swift
//
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

final public class PieChartDrawManager: ChartDrawProtocol {
    // MARK: - Properties
    private var frame: CGRect?
    private var data: ChartData?
    
    // MARK: - init
    public init(frame: CGRect) {
        self.frame = frame
    }
}

// MARK: - Methods
extension PieChartDrawManager {
    public func draw() {
        
    }
    
    public func fetchData(data: ChartData?) {
        self.data = data
    }
}
