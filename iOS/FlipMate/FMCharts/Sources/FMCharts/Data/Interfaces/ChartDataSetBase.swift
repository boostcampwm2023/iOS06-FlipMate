//
//  ChartDataSetBase.swift
//  
//
//  Created by 임현규 on 2024/03/11.
//

import Foundation

public protocol ChartDataSetBase {
    var count: Int { get }
    func entryForIndex(at index: Int) -> ChartDataEntry?
}
