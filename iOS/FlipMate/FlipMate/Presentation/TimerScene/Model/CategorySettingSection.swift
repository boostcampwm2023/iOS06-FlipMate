//
//  CategorySettingSection.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

enum CategorySettingSection: Hashable {
    case categorySection([CategorySettingItem])
}

enum CategorySettingItem: Hashable {
    case categoryCell
}
