//
//  DiskCacherTests.swift
//  
//
//  Created by 권승용 on 3/11/24.
//

import XCTest
@testable import FMImageProvider


fileprivate enum Constant {
    static let cacheDirectoryName = "FlipMateImages"
    static let diskCapacity = 30
}

final class DiskCacherTests: XCTestCase {
    
    private var sut: DiskCacher!
    private let fileManager = FileManager.default

    override func setUp() async throws {
        sut = await DiskCacher(fileManager: fileManager, capacity: Constant.diskCapacity)
    }

    override func tearDownWithError() throws {
        try removeDiskCache()
        sut = nil
    }

    func test_디스크_캐시_save_load_성공() async throws {
        try await sut.save(key: CacheKey.dummy1, imageData: ImageData.dummy)
        
        let result = try await sut.load(key: CacheKey.dummy1)
        XCTAssertEqual(ImageData.dummy, result)
    }
    
    func test_디스크_캐시_load_실패_데이터_없음() async throws {
        do {
            _ = try await sut.load(key: CacheKey.dummy1)
        } catch let error {
            XCTAssertEqual(error as? FMImageProviderError.DiskCacherError, .contentLoadFail)
        }
    }
    
    func test_디스크_캐시_removeAll_성공() async throws {
        try await sut.save(key: CacheKey.dummy1, imageData: ImageData.dummy)
        try await sut.save(key: CacheKey.dummy2, imageData: ImageData.dummy)
        try await sut.removeAll()
        
        do {
            _ = try await sut.load(key: CacheKey.dummy1)
        } catch let error {
            XCTAssertEqual(error as? FMImageProviderError.DiskCacherError, .contentLoadFail)
        }
    }
    
    func test_디스크_캐시_capacity_초과_성공() async throws {
        try await sut.save(key: CacheKey.dummy1, imageData: ImageData.dummy)
        try await sut.save(key: CacheKey.dummy2, imageData: ImageData.dummy)
        try await sut.save(key: CacheKey.dummy3, imageData: ImageData.dummy)
        try await sut.save(key: CacheKey.dummy4, imageData: ImageData.dummy)
        
        do {
            let dummy1 = try await sut.load(key: CacheKey.dummy1)
            XCTAssertEqual(dummy1, nil)
        } catch let error {
            XCTAssertEqual(error as? FMImageProviderError.DiskCacherError, .contentLoadFail)
        }
        
        let dummy2 = try await sut.load(key: CacheKey.dummy2)
        let dummy3 = try await sut.load(key: CacheKey.dummy3)
        let dummy4 = try await sut.load(key: CacheKey.dummy4)
        XCTAssertEqual(dummy2, ImageData.dummy)
        XCTAssertEqual(dummy3, ImageData.dummy)
        XCTAssertEqual(dummy4, ImageData.dummy)
    }
}

private extension DiskCacherTests {
    
    func removeDiskCache() throws {
        guard let cacheDirectoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        let diskCacheDirectory = cacheDirectoryPath.appendingPathComponent(Constant.cacheDirectoryName)
        if fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try fileManager.removeItem(at: diskCacheDirectory)
        }
    }
}
