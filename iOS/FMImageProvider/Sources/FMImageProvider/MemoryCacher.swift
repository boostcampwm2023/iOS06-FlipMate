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
        self.memoryStorage = memoryStorage
    }
        
    func save(key url: String, imageData: Data) {
        memoryStorage.setObject(NSData(data: imageData), forKey: NSString(string: url))
    }
    
    func load(key url: String) throws -> Data {
        guard let imageData = memoryStorage.object(forKey: NSString(string: url)) else {
            throw FMImageProviderError.ImageCacherError.invalidKey
        }
        return Data(imageData)
    }
    
    func removeAll() {
        memoryStorage.removeAllObjects()
    }
    
    private func remove(key url: String) {
        memoryStorage.removeObject(forKey: NSString(string: url))
    }
}
