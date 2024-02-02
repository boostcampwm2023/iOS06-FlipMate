//
//  FMImageProviderError.swift
//  
//
//  Created by 권승용 on 1/22/24.
//

import Foundation

enum FMImageProviderError: Error {
    enum ImageCacherError: LocalizedError {
        case invalidKey
        
        var errorDescription: String? {
            switch self {
            case .invalidKey:
                return "no object found by given key"
            }
        }
    }
    
    enum ImageDownloaderError: LocalizedError {
        case noURL
        
        var errorDescription: String? {
            switch self {
            case .noURL:
                return "no URL"
            }
        }
    }
}
