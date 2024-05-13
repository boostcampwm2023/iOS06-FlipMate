//
//  LRUCacheTests.swift
//  
//
//  Created by 권승용 on 4/3/24.
//

import XCTest
@testable import FMImageProvider

final class LRUCacheTests: XCTestCase {
    private var sut: LRUCache!

    override func setUpWithError() throws {
        sut = LRUCache(capacity: 2)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_get_성공() {
        let key = "key1"
        let data = LRUCacheData(cost: 1, key: key)
        _ = sut.insert(key, data)
        
        let fetchedValue = sut.get(key)
        XCTAssertNotNil(fetchedValue)
        XCTAssertEqual(fetchedValue?.filePath, data.filePath)
    }
    
    func test_get_실패_존재하지_않는_key_nil_반환() {
        let key = "key1"
        
        let fetchedValue = sut.get(key)
        XCTAssertNil(fetchedValue)
    }
    
    func test_insert_성공() {
        let key = "key1"
        let data = LRUCacheData(cost: 1, key: key)
        
        _ = sut.insert(key, data)
        
        let node = sut.nodeList.head
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.data, data)
    }
    
    func test_insert_capacity초과_LRU작동_성공() {
        let key1 = "key1", key2 = "key2", key3 = "key3"
        let data1 = LRUCacheData(cost: 1, key: key1)
        let data2 = LRUCacheData(cost: 1, key: key2)
        let data3 = LRUCacheData(cost: 1, key: key3)

        _ = sut.insert(key1, data1)
        _ = sut.insert(key2, data2)
        _ = sut.insert(key3, data3)
        
        let fetchedValue1 = sut.get(key1)
        XCTAssertNil(fetchedValue1) // Key1 should be evicted
        
        let fetchedValue2 = sut.get(key2)
        XCTAssertNotNil(fetchedValue2)
        XCTAssertEqual(fetchedValue2?.filePath, data2.filePath)
        
        let fetchedValue3 = sut.get(key3)
        XCTAssertNotNil(fetchedValue3)
        XCTAssertEqual(fetchedValue3?.filePath, data3.filePath)
    }
    
    func test_LRU캐시내용으로_배열생성_성공() {
        sut = LRUCache(capacity: 3)
        
        let key1 = "key1", key2 = "key2", key3 = "key3"
        let data1 = LRUCacheData(cost: 1, key: key1)
        let data2 = LRUCacheData(cost: 1, key: key2)
        let data3 = LRUCacheData(cost: 1, key: key3)
        
        _ = sut.insert(key1, data1)
        _ = sut.insert(key2, data2)
        _ = sut.insert(key3, data3)
        
        let arr = [data3, data2, data1]
        let result = sut.makeArray()
        XCTAssertEqual(arr, result)
    }
    
    func test_배열로_LRU캐시_생성_성공() {
        sut = LRUCache(capacity: 3)
        
        let key1 = "key1", key2 = "key2", key3 = "key3"
        let data1 = LRUCacheData(cost: 1, key: key1)
        let data2 = LRUCacheData(cost: 1, key: key2)
        let data3 = LRUCacheData(cost: 1, key: key3)
        
        let arr = [data3, data2, data1]
        
        sut.initWithArr(arr)
        
        XCTAssertEqual(sut.nodeList.head?.data, data3)
        XCTAssertEqual(sut.nodeList.tail?.data, data1)
    }
}
