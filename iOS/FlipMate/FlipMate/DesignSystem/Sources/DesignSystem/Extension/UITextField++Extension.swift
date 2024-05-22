//
//  UITextField++Extension.swift
//  FlipMate
//
//  Created by 신민규 on 11/26/23.
//

import UIKit

extension UITextField {
    public func addLeftPadding(width: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
