//
//  StatusResponseWithErrorDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct StatusResponseWithErrorDTO: Decodable {
    let statusCode: Int
    let message: String
    let error: String
    let path: String
    let timestamp: String
}
