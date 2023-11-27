//
//  UIColor++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/26/23.
//

import UIKit

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255) << 16 | (Int)(green*255) << 8 | (Int)(blue*255) << 0
        
        return String(format: "#%06x", rgb)
    }
}
