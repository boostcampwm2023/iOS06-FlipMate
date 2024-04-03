//
//  LRUCacheTests.swift
//  
//
//  Created by 권승용 on 4/3/24.
//

import XCTest
@testable import FMImageProvider

final class LRUCacheTests: XCTestCase {
    private var sut: LRUCache<CacheData<String, Int>>!

    override func setUpWithError() throws {
        sut = LRUCache(capacity: 2)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_get_성공() {
        let key = "key1"
        let data = CacheData(cost: 1, key: key, data: 10)
        sut.insert(key, data)
        
        let fetchedValue = sut.get(key)
        XCTAssertNotNil(fetchedValue)
        XCTAssertEqual(fetchedValue?.data, data.data)
    }
    
    func test_get_실패_존재하지_않는_key_nil_반환() {
        let key = "key1"
        
        let fetchedValue = sut.get(key)
        XCTAssertNil(fetchedValue)
    }
    
    func test_insert_성공() {
        let key = "key1"
        let data = CacheData(cost: 1, key: key, data: 10)
        
        sut.insert(key, data)
        
        let node = sut.nodeList.head
        XCTAssertNotNil(node)
        XCTAssertEqual(node?.data, data)
    }
    
    func test_insert_capacity초과_LRU작동() {
        let key1 = "key1", key2 = "key2", key3 = "key3"
        let data1 = CacheData(cost: 1, key: key1, data: 10)
        let data2 = CacheData(cost: 1, key: key2, data: 20)
        let data3 = CacheData(cost: 1, key: key3, data: 30)
        
        sut.insert(key1, data1)
        sut.insert(key2, data2)
        sut.insert(key3, data3)
        
        let fetchedValue1 = sut.get(key1)
        XCTAssertNil(fetchedValue1) // Key1 should be evicted
        
        let fetchedValue2 = sut.get(key2)
        XCTAssertNotNil(fetchedValue2)
        XCTAssertEqual(fetchedValue2?.data, data2.data)
        
        let fetchedValue3 = sut.get(key3)
        XCTAssertNotNil(fetchedValue3)
        XCTAssertEqual(fetchedValue3?.data, data3.data)
    }
}
