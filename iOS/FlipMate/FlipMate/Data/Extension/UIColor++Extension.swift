//
//  UIColor++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/26/23.
//

import UIKit

extension UIColor {
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "FFFFFFFF"
        }
        
        var red = components[0]
        var green = components[1]
        var blue = components[2]
        var alpha = components[3]
        
        let hexString = String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(red * 255)),
                               lroundf(Float(green * 255)), lroundf(Float(blue * 255)),
                               lroundf(Float(alpha * 255)))
        
        return hexString
    }
}
