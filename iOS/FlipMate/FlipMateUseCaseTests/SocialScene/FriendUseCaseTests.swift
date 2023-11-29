//
//  FriendUseCaseTests.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import XCTest
import Combine
@testable import FlipMate

final class FriendUseCaseTests: XCTestCase {
    private var friendUseCase: FriendUseCase!
    private var friendRepository: MockFriendRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        self.friendRepository = MockFriendRepository(responseType: .success)
        self.friendUseCase = DefaultFriendUseCase(
            repository: friendRepository)
        self.cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        self.friendUseCase = nil
        self.cancellables = nil
        self.friendRepository = nil
    }
    
    func test_팔로우_요청에_성공하면_응답데이터_변환_성공() {
        let expectation = XCTestExpectation()

        friendUseCase.follow(at: "임현규")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    return
                case .failure(_):
                    XCTFail()
                }
            } receiveValue: { response in
                XCTAssertEqual(response, "성공")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_팔로우_요청에_실패하면_에러응답() {
        let expectation = XCTestExpectation()

        friendRepository.changeResponeType(.failure)
        
        friendUseCase.follow(at: "임현규")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(_):
                    XCTAssert(true)
                }
            } receiveValue: { response in
                XCTFail()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_친구검색_요청에_성공하면_응답데이터_이미지URL로_변환_성공() {
        let expectation = XCTestExpectation()

        friendUseCase.search(at: "임현규")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    return
                case .failure(_):
                    XCTFail()
                }
            } receiveValue: { imageURL in
                XCTAssertEqual(imageURL, "https://flipmate.site:3000")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_친구검색_요청에_실패하면_에러응답() {
        let expectation = XCTestExpectation()
        friendRepository.changeResponeType(.failure)

        friendUseCase.search(at: "임현규")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(_):
                    XCTAssert(true)
                }
            } receiveValue: { response in
                XCTFail()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
}
