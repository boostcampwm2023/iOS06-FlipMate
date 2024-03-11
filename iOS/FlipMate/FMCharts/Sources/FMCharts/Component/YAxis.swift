//
//  YAxis.swift
//  
//
//  Created by 임현규 on 2024/03/02.
//

import Foundation

open class YAxis: AxisBase {
    public override init(enties: [String]) {
        super.init(enties: enties)
    }
    
    public convenience init(enties: [Double]) {
        self.init(enties: enties.map { String($0) })
    }
}
 
