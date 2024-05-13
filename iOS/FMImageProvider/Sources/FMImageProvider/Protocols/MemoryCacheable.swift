//
//  ImageCacheable.swift
//
//
//  Created by 권승용 on 1/22/24.
//

import Foundation

protocol MemoryCacheable {
    func save(key url: String, imageData: Data)
    func load(key url: String) throws -> Data
    func removeAll()
}
