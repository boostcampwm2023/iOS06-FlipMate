//
//  File.swift
//  
//
//  Created by 권승용 on 1/22/24.
//

import Foundation
import CryptoKit

struct LRUCacheRepresentor: Codable {
    private var caches: [LRUCacheData] = []
    
    mutating func setCaches(with caches: [LRUCacheData]) {
        self.caches = caches
    }
    
    func getCaches() -> [LRUCacheData] {
        return caches
    }
}

final class DiskCacher: DiskCacheable {
    private let fileManager: FileManager
    private var cacheDirectory: URL?
    private let lruCache: LRUCache
    
    init?(fileManager: FileManager, capacity: Int) {
        self.fileManager = fileManager
        self.lruCache = LRUCache(capacity: capacity)
        do {
            self.cacheDirectory = try getCacheDirectoryPath()
        } catch let error {
            FMLogger.general.error("initialize failed: \(error)")
            return nil
        }
        try? getLRUCacheStatus()
    }
    
    // MARK: - Interface Methods
    /// 주어진 url을 해시 변환한 값을 파일 이름으로 하여 디스크에 새로운 파일 저장
    /// - Parameters:
    ///   - url: 이미지 주소 url
    ///   - imageData: 이미지 데이터
    func save(key url: String, imageData: Data) throws {
        let filePath = try getFilePath(forKey: url)
        lruCache.insert(url, LRUCacheData(cost: imageData.count, key: filePath.path))
        guard fileManager.createFile(atPath: filePath.path, contents: imageData) else {
            throw FMImageProviderError.DiskCacherError.createFileFailed
        }
        try saveLRUCacheStatus()
    }
    
    /// 주어진 url을 해시 변한한 값을 파일 이름으로 하여 해당 파일을 디스크로부터 불러와 반환
    /// - Parameter url: 이미지 주소 url
    /// - Returns: 불러온 이미지 데이터
    func load(key url: String) throws -> Data {
        guard let filePath = lruCache.get(url)?.filePath else {
            throw FMImageProviderError.DiskCacherError.contentLoadFail
        }
        guard let imageData = fileManager.contents(atPath: filePath) else {
            throw FMImageProviderError.DiskCacherError.contentLoadFail
        }
        return imageData
    }
    
    /// 캐시 디렉토리 및 하위 파일들을 삭제한다
    func removeAll() throws {
        guard let directoryPath = cacheDirectory else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        try fileManager.removeItem(at: directoryPath)
        lruCache.removeAll()
    }
}

// MARK: - Private Methods
extension DiskCacher {
    /// 캐시 파일을 저장할 디렉토리 경로를 불러오는 함수
    /// - Returns: 캐시 파일을 저장할 디렉토리 경로
    private func getCacheDirectoryPath() throws -> URL {
        guard let cacheDirectoryPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        let diskCacheDirectory = cacheDirectoryPath.appendingPathComponent(Constant.cacheDirectoryName)
        if !fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
        }
        return diskCacheDirectory
    }
    
    /// 캐시 디렉토리 내부의 파일을 삭제하는 함수
    /// - Parameter url: 삭제할 파일 url
    private func removeFile(key url: String) throws {
        let filePath = try getFilePath(forKey: url)
        try fileManager.removeItem(at: filePath)
    }
    
    /// 저장될 캐시 파일 경로를 반환하는 함수. 인자로 받은 문자열에 대한 16진수 해시값을 파일 이름으로 사용한다.
    /// - Parameter key: 파일을 저장할 key가 되는 문자열
    /// - Returns: key 값을 사용해 계산한 캐시 디렉토리 내의 파일 경로
    private func getFilePath(forKey key: String) throws -> URL {
        let fileName = hashToHexString(from: key)
        guard let filePath = cacheDirectory?.appendingPathComponent(fileName, isDirectory: false) else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        return filePath
    }
    
    /// 문자열을 최대 16자리 해시 값 문자열로 변환하는 함수
    /// - Parameter str: 변환할 문자열
    /// - Returns: SHA-2 알고리즘을 사용해 변환한 해시 값 문자열
    private func hashToHexString(from str: String) -> String {
        let hash = SHA256.hash(data: str.data(using: .utf8)!)
        let hexString = hash.reduce("") { $0 + String(format: "%02x", $1) }
        let truncatedHexString = String(hexString.prefix(16))
        return truncatedHexString
    }
    
    /// LRUCache 표현을 디스크에 JSON 포맷으로 저장하는 함수
    private func saveLRUCacheStatus() throws {
        guard let filePath = cacheDirectory?.appendingPathComponent(Constant.lruCacheRepresentorName) else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        let arr = lruCache.makeArray()

        var cacheRepresenter = LRUCacheRepresentor()
        cacheRepresenter.setCaches(with: arr)
        
        let data = try JSONEncoder().encode(cacheRepresenter)
        fileManager.createFile(atPath: filePath.path, contents: data)
    }
    
    /// 디스크로부터 LRUCache 표현을 불러와 LRUCache 인스턴스에 저장하는 함수
    private func getLRUCacheStatus() throws {
        guard let filePath = cacheDirectory?.appendingPathComponent(Constant.lruCacheRepresentorName) else {
            // LRUCache 파일이 없을 수 있기 때문에 오류 던지기 대신 함수 종료
            return
        }
        guard let fileData = fileManager.contents(atPath: filePath.path) else {
            throw FMImageProviderError.DiskCacherError.contentLoadFail
        }
        
        let lruRepresentor = try JSONDecoder().decode(LRUCacheRepresentor.self, from: fileData)
        let caches = lruRepresentor.getCaches()
        lruCache.initWithArr(caches)
    }
}

enum Constant {
    static let cacheDirectoryName = "FlipMateImages"
    static let lruCacheRepresentorName = "CacheRepresentor"
}
