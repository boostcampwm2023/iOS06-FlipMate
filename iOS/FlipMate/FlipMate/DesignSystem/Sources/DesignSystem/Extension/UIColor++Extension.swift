//
//  UIColor++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/26/23.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgb & 0x000000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "FFFFFFFF"
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        
        let hexString = String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(red * 255)),
                               lroundf(Float(green * 255)), lroundf(Float(blue * 255)),
                               lroundf(Float(alpha * 255)))
        
        return hexString
    }
}
