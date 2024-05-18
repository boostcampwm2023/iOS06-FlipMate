//
//  FlipMateColor.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

public enum FlipMateColor {
    case darkBlue
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case tabBarColor
    case tabBarLayerColor
    case tabBarIconSelected
    case tabBarIconUnSelected
    case warningRed
    case approveGreen

    public var color: UIColor? {
        switch self {
        case .darkBlue:
            return UIColor(named: "DarkBlue", in: Bundle.module, compatibleWith: nil)
        case .gray1:
            return UIColor(named: "Gray1", in: Bundle.module, compatibleWith: nil)
        case .gray2:
            return UIColor(named: "Gray2", in: Bundle.module, compatibleWith: nil)
        case .gray3:
            return UIColor(named: "Gray3", in: Bundle.module, compatibleWith: nil)
        case .gray4:
            return UIColor(named: "Gray4", in: Bundle.module, compatibleWith: nil)
        case .gray5:
            return UIColor(named: "Gray5", in: Bundle.module, compatibleWith: nil)
        case .tabBarColor:
            return UIColor(named: "TabBarColor", in: Bundle.module, compatibleWith: nil)
        case .tabBarLayerColor:
            return UIColor(named: "TabBarLayerColor", in: Bundle.module, compatibleWith: nil)
        case .tabBarIconSelected:
            return UIColor(named: "TabBarIconSelected", in: Bundle.module, compatibleWith: nil)
        case .tabBarIconUnSelected:
            return UIColor(named: "TabBarIconUnSelected", in: Bundle.module, compatibleWith: nil)
        case .warningRed:
            return UIColor(named: "WarningRed", in: Bundle.module, compatibleWith: nil)
        case .approveGreen:
            return UIColor(named: "ApproveGreen", in: Bundle.module, compatibleWith: nil)
        }
    }
}
