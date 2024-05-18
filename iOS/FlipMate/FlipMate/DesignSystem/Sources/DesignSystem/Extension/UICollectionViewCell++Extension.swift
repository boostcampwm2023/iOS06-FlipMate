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
