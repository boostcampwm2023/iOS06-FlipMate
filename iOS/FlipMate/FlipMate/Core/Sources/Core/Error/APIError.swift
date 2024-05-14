//
//  APIError.swift
//  
//
//  Created by 권승용 on 5/14/24.
//

import Foundation

public enum APIError: Error {
    case duplicatedCategoryName
    case duplicatedNickName
    case imageNotSafe
    case unknown
}
