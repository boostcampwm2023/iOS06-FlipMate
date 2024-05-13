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
    static let cacheDirectoryName = "FlipMateImages"
}

final class FMImageProviderTests: XCTestCase {
    private var sut: FMImageProvider!

    override func setUp() async throws {
        let memoryCacher = MemoryCacher(memoryStorage: NSCache<NSString, NSData>(), capacity: Constant.memoryCapacity)
        let diskCacher = DiskCacher(fileManager: FileManager.default, capacity: Constant.diskCapacity)
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let imageDownloader = ImageDownloader(session: URLSession(configuration: configuration))
        sut = FMImageProvider(memoryCacher: memoryCacher, diskCacher: diskCacher, imageDownloader: imageDownloader)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        try removeDiskCache()
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
    
    func test_clearAllCaches_성공() async throws {
        let memoryStorage = NSCache<NSString, NSData>()
        let memoryCacher = MemoryCacher(memoryStorage: memoryStorage, capacity: Constant.memoryCapacity)
        
        let diskStorage = FileManager.default
        let diskCacher = DiskCacher(fileManager: diskStorage, capacity: Constant.diskCapacity)
            
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
        await fulfillment(of: [expectation], timeout: 5)
        
        try await sut.clearAllCaches()
        
        let clearedMemoryObject = memoryStorage.object(forKey: "https://example.com") as? Data
        XCTAssertEqual(clearedMemoryObject, nil)
        
        let dummy = try await diskCacher.load(key: Constant.exampleURL)
        XCTAssertEqual(dummy, nil)
    }
}

private extension FMImageProviderTests {
    
    func removeDiskCache() throws {
        let fileManager = FileManager.default
        guard let cacheDirectoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FMImageProviderError.DiskCacherError.cacheDirectoryNil
        }
        let diskCacheDirectory = cacheDirectoryPath.appendingPathComponent(Constant.cacheDirectoryName)
        if fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try fileManager.removeItem(at: diskCacheDirectory)
        }
    }
}
