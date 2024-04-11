//
//  FMImageProviderTests.swift
//  
//
//  Created by 권승용 on 3/28/24.
//

import XCTest
@testable import FMImageProvider

fileprivate enum Constant {
    static let memoryCapacity = 100_000_000
    static let diskCapacity = 100_000_000
    static let exampleURL = "https://example.com"
}

final class FMImageProviderTests: XCTestCase {
    private var sut: FMImageProvider!

    override func setUpWithError() throws {
        let memoryCacher = MemoryCacher(memoryStorage: NSCache<NSString, NSData>(), capacity: Constant.memoryCapacity)
        guard let diskCacher = DiskCacher(fileManager: FakeFileManager(), capacity: Constant.diskCapacity) else {
            assertionFailure("디스크 캐시 초기화 실패")
            return
        }
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let imageDownloader = ImageDownloader(session: URLSession(configuration: configuration))
        sut = FMImageProvider(memoryCacher: memoryCacher, diskCacher: diskCacher, imageDownloader: imageDownloader)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        sut = nil
    }
    
    func test_fetchImageData_성공() throws {
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), ImageData.dummy)
        }
        
        let expectation = XCTestExpectation(description: "response")
        sut.fetchImageData(from: URL(string: Constant.exampleURL)!) { result in
            switch result {
            case .success(let data):
                print(data)
                XCTAssertEqual(data, ImageData.dummy)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("test failed with error: \(error)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchImageData_async_성공() async throws {
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), ImageData.dummy)
        }
        
        let data = try await sut.fetchImageData(from: URL(string: Constant.exampleURL)!)
        XCTAssertEqual(data, ImageData.dummy)
    }
    
    func test_clearAllCaches_성공() throws {
        let memoryStorage = NSCache<NSString, NSData>()
        let memoryCacher = MemoryCacher(memoryStorage: memoryStorage, capacity: Constant.memoryCapacity)
        
        let diskStorage = FakeFileManager()
        guard let diskCacher = DiskCacher(fileManager: diskStorage, capacity: Constant.diskCapacity) else {
            assertionFailure("디스크 캐시 초기화 실패")
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        sut = FMImageProvider(memoryCacher: memoryCacher, diskCacher: diskCacher, imageDownloader: ImageDownloader(session: session))
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), ImageData.dummy)
        }
        
        let expectation = XCTestExpectation()
        sut.fetchImageData(from: URL(string: Constant.exampleURL)!) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        let memoryObject = memoryStorage.object(forKey: "https://example.com") as? Data
        let cacheCount = diskStorage.diskCache.count
        
        guard memoryObject! == ImageData.dummy, cacheCount == 1 else {
            XCTFail()
            return
        }
        
        try sut.clearAllCaches()
        
        let clearedMemoryObject = memoryStorage.object(forKey: "https://example.com") as? Data
        let diskCacheCount = diskStorage.diskCache.count
        
        XCTAssertEqual(clearedMemoryObject, nil)
        XCTAssertEqual(diskCacheCount, 0)
    }
}
