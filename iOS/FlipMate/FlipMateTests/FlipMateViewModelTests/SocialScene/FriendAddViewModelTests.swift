//
//  FriendAddViewModelTests.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import XCTest
import Combine
@testable import FlipMate

private enum Constant {
    static let imageURL = "imageURL"
}

private final class SearchFriendUseCaseStub: SearchFriendUseCase {
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError> {
        return CurrentValueSubject(FriendSearchResult(status: .notFriend, imageURL: Constant.imageURL)).eraseToAnyPublisher()
    }
}

private final class SearchFriendUseCaseErrorStub: SearchFriendUseCase {
    func search(at nickname: String) -> AnyPublisher<FriendSearchResult, NetworkError> {
        return Fail(error: NetworkError.bodyEmpty).eraseToAnyPublisher()
    }
}

final class FriendAddViewModelTests: XCTestCase {
    private var sut: FriendAddViewModelProtocol!
    
    override func setUpWithError() throws {
        sut = FriendAddViewModel(
            followUseCase: DummyFollowFriendUseCase(),
            searchUseCase: SearchFriendUseCaseStub(),
            userInfoManager: DummyUserInfoManager())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_닉네임_검색요청_성공시_imageURL리턴_성공() {
        let expectation = XCTestExpectation()
        var received: String!
        let cancellable = sut.searchFreindPublisher
            .sink { friend in
                received = friend.iamgeURL
                expectation.fulfill()
            }
        
        sut.didSearchFriend()
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(received, Constant.imageURL)
        cancellable.cancel()
    }
    
    func test_닉네임_검색요청_실패시_에러_응답_성공() {
        sut = FriendAddViewModel(
            followUseCase: DummyFollowFriendUseCase(),
            searchUseCase: SearchFriendUseCaseErrorStub(),
            userInfoManager: DummyUserInfoManager())
        let expectation = XCTestExpectation()
        var received: NetworkError!
        let cancellable = sut.searchErrorPublisher
            .sink { error in
                received = error as? NetworkError
                expectation.fulfill()
            }

        sut.didSearchFriend()
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(received, .bodyEmpty)
        cancellable.cancel()
    }
    
    func test_닉네임_입력시_자릿수_카운팅_성공() {
        let expectation = XCTestExpectation()
        var received: Int!
        let cancellable = sut.nicknameCountPublisher
            .sink { count in
                received = count
                expectation.fulfill()
            }
        
        sut.nicknameDidChange(at: "flipmate")
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(received, 8)
        cancellable.cancel()
    }
}
