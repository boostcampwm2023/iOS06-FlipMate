//
//  StatusResponseWithErrorDTO.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct StatusResponseWithErrorDTO: Decodable {
    let message: String
    let error: String
    let statusCode: Int
}
