//
//  ImageCacher.swift
//  
//
//  Created by 권승용 on 1/22/24.
//

import Foundation

final class MemoryCacher: MemoryCacheable {
    private var memoryStorage: NSCache<NSString, NSData>
    
    init(memoryStorage: NSCache<NSString, NSData>) {
        memoryStorage.name = "FMImageProviderCache"
        memoryStorage.countLimit = 0
        memoryStorage.totalCostLimit = 1_000_000_000 // 최대 메모리 캐시 크기 100MB
        self.memoryStorage = memoryStorage
    }
        
    // MARK: - Interface Methods
    /// 메모리 캐시에 이미지 데이터를 저장하는 함수
    /// - Parameters:
    ///   - url: key로 사용할 이미지 url
    ///   - imageData: 저장할 이미지 데이터
    func save(key url: String, imageData: Data) {
        memoryStorage.setObject(NSData(data: imageData), forKey: NSString(string: url), cost: imageData.count)
    }
    
    /// 메모리 캐시로부터 이미지 데이터를 불러오는 함수
    /// - Parameter url: key로 사용할 이미지 url
    /// - Returns: 불러올 이미지 데이터
    func load(key url: String) throws -> Data {
        guard let imageData = memoryStorage.object(forKey: NSString(string: url)) else {
            throw FMImageProviderError.MemoryCacherError.invalidKey
        }
        return Data(imageData)
    }
    
    /// 메모리 캐시에 저장된 모든 객체를 삭제하는 함수
    func removeAll() {
        memoryStorage.removeAllObjects()
    }
}

// MARK: - Private Methods
extension MemoryCacher {
    /// 저장된 캐시 객체를 삭제하는 함수
    /// - Parameter url: 삭제할 객체의 key
    private func remove(key url: String) {
        memoryStorage.removeObject(forKey: NSString(string: url))
    }
}
