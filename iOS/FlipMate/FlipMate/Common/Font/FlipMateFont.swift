//
//  FlipMateFont.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

enum FlipMateFont {
    case largeRegular
    case semiLargeRegular
    case mediumRegular
    case smallRegular
    case caption
    case extraLargeBold
    case largeBold
    case semiLargeBold
    case mediumBold
    case smallBold
    
    var font: UIFont {
        switch self {
        case .largeRegular: return .systemFont(ofSize: 32, weight: .regular)
        case .semiLargeRegular: return .systemFont(ofSize: 24, weight: .regular)
        case .mediumRegular: return .systemFont(ofSize: 18, weight: .regular)
        case .smallRegular: return .systemFont(ofSize: 14, weight: .regular)
        case .caption: return .systemFont(ofSize: 12, weight: .regular)
        case .extraLargeBold: return .systemFont(ofSize: 58, weight: .bold)
        case .largeBold: return .systemFont(ofSize: 32, weight: .bold)
        case .semiLargeBold: return .systemFont(ofSize: 24, weight: .bold)
        case .mediumBold: return .systemFont(ofSize: 18, weight: .bold)
        case .smallBold: return .systemFont(ofSize: 14, weight: .bold)
        }
    }
}
