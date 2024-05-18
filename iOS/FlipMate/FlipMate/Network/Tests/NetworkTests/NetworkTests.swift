//
//  NetworkTests.swift
//
//
//  Created by 권승용 on 5/16/24.
//

import XCTest
import Combine
@testable import Network
@testable import Core

final class NetworkTests: XCTestCase {
    private var sut: Provider!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = Provider(urlSession: session, keychainManager: MockKeychainManager())
    }
    
    override func tearDownWithError() throws {
        // MockURLProtocol의 requestHandler는 static 프로퍼티이기 때문에 전역적으로 사용 가능하다. 따라서 사용 후 항상 nil로 초기화 해주어 사이드 이펙트를 방지한다.
        MockURLProtocol.requestHandler = nil
        sut = nil
    }
    
    /// 요청 성공 with Combine
    func test_Request_성공_200() throws {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: TestConstant.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(TestConstant.dummyData)
            return (response, data)
        }
        
        var result: TestCodableType!
        let endpoint = EndPoint<TestCodableType>(baseURL: TestConstant.url.path, path: TestConstant.path, method: .get)
        
        let expectation = XCTestExpectation(description: "request")
        let cancellable = sut.request(with: endpoint)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Test Failed with error: \(error)")
                }
            } receiveValue: { response in
                result = response
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(result, TestConstant.dummyData)
        cancellable.cancel()
    }
    
    /// 요청 성공 with async / await
    func test_Request_성공_200_async() async throws {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: TestConstant.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(TestConstant.dummyData)
            return (response, data)
        }
        
        let endpoint = EndPoint<TestCodableType>(baseURL: TestConstant.url.path, path: TestConstant.path, method: .get)
        
        let result = try await sut.request(with: endpoint)
        XCTAssertEqual(result, TestConstant.dummyData)
    }
    
    /// 요청 실패 with Combine
    func test_Request_실패_404() throws {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: TestConstant.url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data("404 오류".utf8))
        }
        
        let endpoint = EndPoint<TestCodableType>(baseURL: TestConstant.url.path, path: TestConstant.path, method: .get)
        
        let expectation = XCTestExpectation(description: "request")
        let cancellable = sut.request(with: endpoint)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertEqual(error, NetworkError.statusCodeError(statusCode: 404, message: "404 오류"))
                    expectation.fulfill()
                }
            } receiveValue: { response in
                XCTFail("Test Filed")
            }
        wait(for: [expectation], timeout: 5)
        
        cancellable.cancel()
    }
    
    /// 요청 실패 with async / await
    func test_Request_실패_404_async() async throws {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: TestConstant.url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data("404 오류".utf8))
        }
        
        let endpoint = EndPoint<TestCodableType>(baseURL: TestConstant.url.path, path: TestConstant.path, method: .get)
        
        do {
            _ = try await sut.request(with: endpoint)
        } catch let error {
            guard let error = error as? NetworkError else {
                XCTFail("Test Failed")
                return
            }
            
            XCTAssertEqual(error, .statusCodeError(statusCode: 404, message: "404 오류"))
        }
    }
}
