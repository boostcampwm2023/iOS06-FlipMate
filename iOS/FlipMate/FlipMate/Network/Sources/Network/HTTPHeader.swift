//
//  HTTPHeader.swift
//  
//
//  Created by 권승용 on 5/15/24.
//

import Foundation

public struct HTTPHeader {
    var value: String
    var field: String
    
    public init(value: String, field: String) {
        self.value = value
        self.field = field
    }
}
