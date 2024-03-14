//
//
//  MemoryCacherTests.swift
//
//
//  Created by 권승용 on 3/11/24.
//

import XCTest
@testable import FMImageProvider

enum ImageData {
    static let dummy = Data(count: 1000)
}

enum CacheKey {
    static let dummy = "https://dummyURL"
}

final class MemoryCacherTests: XCTestCase {
    private var sut: MemoryCacher!

    override func setUpWithError() throws {
        let storage = NSCache<NSString, NSData>()
        sut = MemoryCacher(memoryStorage: storage)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_메모리_캐시_저장_성공() {
        // arrange
        let storage = NSCache<NSString, NSData>()
        sut = MemoryCacher(memoryStorage: storage)
        
        // act
        sut.save(key: CacheKey.dummy, imageData: ImageData.dummy)
        
        // assert
        let result = storage.object(forKey: CacheKey.dummy as NSString) as? Data
        XCTAssertEqual(ImageData.dummy, result)
    }
    
    func test_메모리_캐시_load_성공() throws {
        // arrange
        let storage = NSCache<NSString, NSData>()
        storage.setObject(NSData(data: ImageData.dummy), forKey: NSString(string: CacheKey.dummy))
        sut = MemoryCacher(memoryStorage: storage)
        
        // act
        let result = try sut.load(key: CacheKey.dummy)
        
        // assert
        XCTAssertEqual(result, ImageData.dummy)
    }
    
    func test_메모리_캐시_removeAll_성공() throws {
        // arrange
        let storage = NSCache<NSString, NSData>()
        storage.setObject(NSData(data: ImageData.dummy), forKey: NSString(string: CacheKey.dummy))
        sut = MemoryCacher(memoryStorage: storage)
        
        // act
        sut.removeAll()
        
        // assert
        do {
            _ = try sut.load(key: CacheKey.dummy)
            XCTFail("cache not removed")
        } catch let error  {
            XCTAssertEqual(error as? FMImageProviderError.ImageCacherError, FMImageProviderError.ImageCacherError.invalidKey)
        }
    }
}
