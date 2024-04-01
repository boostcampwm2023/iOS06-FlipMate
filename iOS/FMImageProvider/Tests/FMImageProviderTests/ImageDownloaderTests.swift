//
//  ImageDownloaderTests.swift
//  
//
//  Created by 권승용 on 3/11/24.
//

import XCTest
@testable import FMImageProvider

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("no request handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

final class ImageDownloaderTests: XCTestCase {
    private var sut: ImageDownloader!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = ImageDownloader(session: session)
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        sut = nil
    }
    
    func test_fetchImage_성공() {
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), ImageData.dummy)
        }
        
        let expectation = XCTestExpectation(description: "response")
        sut.fetchImage(from: URL(string:"https://example.com")!) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, ImageData.dummy)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("test failed with error: \(error)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchImage_async_성공() async throws {
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), ImageData.dummy)
        }
        
        let data = try await sut.fetchImage(from: URL(string: "https://example.com")!)
        XCTAssertEqual(data, ImageData.dummy)
    }
}
