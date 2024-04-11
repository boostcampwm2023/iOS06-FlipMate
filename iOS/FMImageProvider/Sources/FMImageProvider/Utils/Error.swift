//
//  FMImageProviderError.swift
//  
//
//  Created by 권승용 on 1/22/24.
//

import Foundation

enum FMImageProviderError: Error, Equatable {
    enum MemoryCacherError: LocalizedError {
        case invalidKey
        
        var errorDescription: String? {
            switch self {
            case .invalidKey:
                return "no object found by given key"
            }
        }
    }
    
    enum DiskCacherError: LocalizedError {
        case cacheDirectoryNil
        case createFileFailed
        case contentLoadFail
        case filePathNotInLRUCache
        
        var errorDescription: String? {
            switch self {
            case .cacheDirectoryNil:
                return "cache directory initializing failed"
            case .createFileFailed:
                return "creating file failed from fileManager"
            case .contentLoadFail:
                return "content load failed from fileManager"
            case .filePathNotInLRUCache:
                return "filePath not registered in LRU Cache"
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
