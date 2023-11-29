//
//  FlipMateColor.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

enum FlipMateColor {
    case darkBlue
    case gray1
    case gray2
    case gray3
    case gray4
    case tabBarColor
    case tabBarLayerColor
    case warningRed
    case approveGreen

    var color: UIColor? {
        switch self {
        case .darkBlue:
            return UIColor(named: "DarkBlue")
        case .gray1:
            return UIColor(named: "Gray1")
        case .gray2:
            return UIColor(named: "Gray2")
        case .gray3:
            return UIColor(named: "Gray3")
        case .gray4:
            return UIColor(named: "Gray4")
        case .tabBarColor:
            return UIColor(named: "TabBarColor")
        case .tabBarLayerColor:
            return UIColor(named: "TabBarLayerColor")
        case .warningRed:
            return UIColor(resource: .warningRed)
        case .approveGreen:
            return UIColor(resource: .approveGreen)
        }
    }
}
