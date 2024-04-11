//
//
//  MemoryCacherTests.swift
//
//
//  Created by 권승용 on 3/11/24.
//

import XCTest
@testable import FMImageProvider

fileprivate enum Constant {
    static let memoryCapacity = 100_000_000
}

final class MemoryCacherTests: XCTestCase {
    private var sut: MemoryCacher!

    override func setUpWithError() throws {
        let storage = NSCache<NSString, NSData>()
        sut = MemoryCacher(memoryStorage: storage, capacity: Constant.memoryCapacity)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_메모리_캐시_저장_성공() {
        // arrange
        let storage = NSCache<NSString, NSData>()
        sut = MemoryCacher(memoryStorage: storage, capacity: Constant.memoryCapacity)
        
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
        sut = MemoryCacher(memoryStorage: storage, capacity: Constant.memoryCapacity)
        
        // act
        let result = try sut.load(key: CacheKey.dummy)
        
        // assert
        XCTAssertEqual(result, ImageData.dummy)
    }
    
    func test_메모리_캐시_removeAll_성공() throws {
        // arrange
        let storage = NSCache<NSString, NSData>()
        storage.setObject(NSData(data: ImageData.dummy), forKey: NSString(string: CacheKey.dummy))
        sut = MemoryCacher(memoryStorage: storage, capacity: Constant.memoryCapacity)
        
        // act
        sut.removeAll()
        
        // assert
        do {
            _ = try sut.load(key: CacheKey.dummy)
            XCTFail("cache not removed")
        } catch let error  {
            XCTAssertEqual(error as? FMImageProviderError.MemoryCacherError, FMImageProviderError.MemoryCacherError.invalidKey)
        }
    }
}
