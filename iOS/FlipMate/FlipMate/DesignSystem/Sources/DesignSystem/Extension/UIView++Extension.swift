//
//  UIView++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import UIKit

extension UIView {
    public func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
}
