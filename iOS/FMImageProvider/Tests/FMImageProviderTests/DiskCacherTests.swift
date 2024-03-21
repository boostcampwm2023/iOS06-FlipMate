//
//  DiskCacherTests.swift
//  
//
//  Created by 권승용 on 3/11/24.
//

import XCTest
@testable import FMImageProvider

enum FileType {
    case directory
    case file
}

final class FakeFileManager: FileManager {
    var diskCache: [String:Data] = [:]
    private var fileTypeCache: [String:FileType] = [:]
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        let url = URL(fileURLWithPath: "/path/to/cacheDirectory/")
        return [url]
    }
    
    override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        diskCache[path] = data
        fileTypeCache[path] = .file
        return true
    }
    
    override func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        fileTypeCache[path] = .directory
        return
    }
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        fileTypeCache[url.path] = .directory
        return
    }
    
    override func contents(atPath path: String) -> Data? {
        let data = diskCache[path]
        return data
    }
    
    override func removeItem(at URL: URL) throws {
        FMLogger.test.log("\(URL.path)")
        switch fileTypeCache[URL.path] {
        case .directory:
            diskCache = [:]
            fileTypeCache = [:]
        case .file:
            diskCache[URL.path] = nil
            fileTypeCache[URL.path] = nil
        default:
            break
        }
    }
    
    override func fileExists(atPath path: String) -> Bool {
        if let _ = diskCache[path] {
            return true
        } else {
            return false
        }
    }
}

final class DiskCacherTests: XCTestCase {
    private var sut: DiskCacher!
    private let fileManager = FakeFileManager()

    override func setUpWithError() throws {
        sut = DiskCacher(fileManager: fileManager)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_디스크_캐시_save_load_성공() throws {
        try sut.save(key: CacheKey.dummy, imageData: ImageData.dummy)
        
        let result = try sut.load(key: CacheKey.dummy)
        XCTAssertEqual(ImageData.dummy, result)
    }
    
    func test_디스크_캐시_load_실패_데이터_없음() throws {
        do {
            _ = try sut.load(key: CacheKey.dummy)
        } catch let error {
            XCTAssertEqual(error as? FMImageProviderError.DiskCacherError, .contentLoadFail)
        }
    }
    
    func test_디스크_캐시_removeAll_성공() throws {
        try sut.save(key: CacheKey.dummy, imageData: ImageData.dummy)
        
        try sut.removeAll()
        
        let cacheCount = fileManager.diskCache.count
        XCTAssertEqual(cacheCount, 0)
    }
}
