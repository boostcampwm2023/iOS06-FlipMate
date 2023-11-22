//
//  StatusResponseDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/22/23.
//

import Foundation

struct StatusResponseDTO: Decodable {
    let statusCode: Int
    let message: String
}
