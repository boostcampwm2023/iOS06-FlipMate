//
//  FlipMateTests.swift
//  FlipMateTests
//
//  Created by 권승용 on 11/9/23.
//

import XCTest
import Combine
@testable import FlipMate

struct MockResponse {
    let data: Data?
    let urlResponse: URLResponse?
    let error: NetworkError?
}

class MockURLSession: URLSessionable {
    let response: MockResponse
    
    init(response: MockResponse) {
        self.response = response
    }
    
    func response(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        let status = response.urlResponse as! HTTPURLResponse
        let httpResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: status.statusCode,
            httpVersion: nil,
            headerFields: nil)!
        
        guard let data = response.data else { return Just((data: Data(), response: httpResponse))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
        return Just((data: data, response: httpResponse))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

final class NetworkServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_타이머_시작_200_응답_성공() {
        let expectation = XCTestExpectation()
        let url = "http://baseURL"
        let requestData =
        """
            {
              "date": "2023-11-23",
              "created_at": "2023-11-23 11:00:12",
              "type": "start",
              "learning_time": 3600,
              "user_id": 1,
              "category_id": 1
            }
        """
        let responseData =
        """
            {
              "date": "2023-11-23",
              "created_at": "2023-11-23 11:00:12",
              "type": "start",
              "learning_time": 3600,
              "user_id": 1,
              "category_id": 1
            }
        """
        let mockResponse = MockResponse(
            data: responseData.data(using: .utf8),
            urlResponse: HTTPURLResponse(
                url: URL(string:url)!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil),
            error: nil)
        let provider = Provider(urlSession: MockURLSession(response: mockResponse))
        
        let endpoint = EndPoint<TimerStartResponseDTO>(baseURL: "http://baseURL", path: "timer", method: .get)
        
        provider.request(with: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    return
                case .failure(_):
                    XCTFail()
                    return
                }
            } receiveValue: { response in
                XCTAssertEqual(response.type, "start")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
}
