//
//  FriendAddViewModelTests.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import XCTest
import Combine

final class FriendAddViewModelTests: XCTestCase {
    private var viewModel: FriendAddViewModelProtocol!
    private var mockUseCase = MockFriendUseCase(type: .success)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        self.viewModel = FriendAddViewModel(
            friendUseCase: mockUseCase)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
    }
    
    func test_닉네임_검색요청_성공시_imageURL리턴_성공() {
        let expectation = XCTestExpectation()
        self.viewModel.didSearchFriend()

        self.viewModel.searchFreindPublisher
            .receive(on: DispatchQueue.main)
            .sink { friend in
                print(friend.profileImageURL)
                XCTAssertEqual(friend.profileImageURL, "https://flipmate.site:3000")
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_닉네임_검색요청_실패시_에러_응답_성공() {
        let expectation = XCTestExpectation()
        mockUseCase.changeType(type: .failure)
        
        self.viewModel.searchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                XCTAssert(true)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        self.viewModel.didSearchFriend()

        wait(for: [expectation], timeout: 5)
    }
    
    func test_닉네임_입력시_자릿수_카운팅_성공() {
        let expectation = XCTestExpectation()
        self.viewModel.nicknameCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { count in
                print(count)
                XCTAssertEqual(count, 8)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        self.viewModel.nicknameDidChange(at: "flipmate")
        
        wait(for: [expectation], timeout: 5)
    }
}
