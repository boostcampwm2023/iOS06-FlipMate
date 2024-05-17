//
//  UIViewController++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/10.
//

import UIKit

extension UIViewController {
    public func showToast(title: String) {
        let toastLabel = UILabel(frame: CGRect(
            x: 40,
            y: self.view.frame.height / 2,
            width: self.view.frame.width - 80,
            height: 50)
        )
        
        toastLabel.backgroundColor = FlipMateColor.gray4.color?.withAlphaComponent(0.5)
        toastLabel.textColor = .label
        toastLabel.textAlignment = .center
        toastLabel.font = FlipMateFont.smallRegular.font
        toastLabel.text = title
        toastLabel.clipsToBounds = true
        toastLabel.layer.cornerRadius = 10
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
