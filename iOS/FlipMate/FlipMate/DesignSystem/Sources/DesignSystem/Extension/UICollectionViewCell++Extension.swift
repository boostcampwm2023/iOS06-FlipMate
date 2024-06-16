//
//  UICollectionViewCell++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    public func configureCategoryCellLayer() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        layer.borderColor = FlipMateColor.gray2.color?.cgColor
    }
}
