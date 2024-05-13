//
//  DiskCacheable.swift
//  
//
//  Created by 권승용 on 1/22/24.
//

import Foundation

protocol DiskCacheable {
    func save(key url: String, imageData: Data) async throws
    func load(key url: String) async throws -> Data?
    func removeAll() async throws
}
