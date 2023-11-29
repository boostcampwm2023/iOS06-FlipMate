//
//  FriendChartResponseDTO.swift
//  FlipMate
//
//  Created by 신민규 on 11/30/23.
//

import Foundation

struct FriendChartResponseDTO: Decodable {
    let myData: [Int]
    let followingData: [Int]
    let primaryCategory: String
    
    private enum CodingKeys: String, CodingKey {
        case myData = "my_daily_data"
        case followingData = "following_daily_data"
        case primaryCategory = "following_primary_category"
    }
}
