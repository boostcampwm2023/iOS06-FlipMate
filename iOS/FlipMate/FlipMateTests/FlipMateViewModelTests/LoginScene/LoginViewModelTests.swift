//
//  LoginViewModel.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/8/24.
//

import Foundation
import XCTest
import Combine
@testable import FlipMate

private enum TestToken {
    static let success = "success"
    static let fail = "fail"
}

private enum LoginError: Error {
    case loginError
}

private final class GoogleLoginUseCaseStub: GoogleLoginUseCase {
    func googleLogin(accessToken: String) async throws -> User {
        if accessToken == TestToken.success {
            return User(isMember: true, accessToken: accessToken)
        } else {
            throw LoginError.loginError
        }
    }
}

private final class AppleLoginUseCaseStub: AppleLoginUseCase {
    func appleLogin(accessToken: String, userID: String) async throws -> User {
        if accessToken == TestToken.success {
            return User(isMember: true, accessToken: accessToken)
        } else {
            throw LoginError.loginError
        }
    }
}

final class LoginViewModelTests: XCTestCase {
    private var sut: LoginViewModelProtocol!
 
    override func setUpWithError() throws {
        sut = LoginViewModel(
            googleLoginUseCase: GoogleLoginUseCaseStub(),
            appleLoginUseCase: AppleLoginUseCaseStub())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_구글로그인_성공_true_반환() throws {
        // arrange
        let expectation = XCTestExpectation()
        var received: Bool!
        let cancellable = sut.isMemberPublisher
            .sink { isMember in
                received = isMember
                expectation.fulfill()
            }
        
        // act
        sut.requestGoogleLogin(accessToken: TestToken.success)
        wait(for: [expectation], timeout: 10)
        
        // assert
        XCTAssertEqual(received, true)
        cancellable.cancel()
    }
    
    func test_구글로그인_실패_error_throw() throws {
        // arrange
        let expectation = XCTestExpectation()
        var received: LoginError!
        let cancellable = sut.errorPublisher
            .sink { error in
                received = error as? LoginError
                expectation.fulfill()
            }
        
        // act
        sut.requestGoogleLogin(accessToken: TestToken.fail)
        wait(for: [expectation], timeout: 10)
        
        // assert
        XCTAssertEqual(received, LoginError.loginError)
        cancellable.cancel()
    }
    
    func test_애플로그인_성공_true_반환() {
        // arrange
        let expectation = XCTestExpectation()
        var received: Bool!
        let cancellable = sut.isMemberPublisher
            .sink { isMember in
                received = isMember
                expectation.fulfill()
            }
        
        // act
        sut.requestAppleLogin(accessToken: TestToken.success, userID: TestToken.success)
        wait(for: [expectation], timeout: 10)
        
        // assert
        XCTAssertEqual(received, true)
        cancellable.cancel()
    }
    
    func test_애플로그인_실패_error_throw() {
        // arrange
        let expectation = XCTestExpectation()
        var received: LoginError!
        let cancellable = sut.errorPublisher
            .sink { error in
                received = error as? LoginError
                expectation.fulfill()
            }
        
        // act
        sut.requestAppleLogin(accessToken: TestToken.fail, userID: TestToken.fail)
        wait(for: [expectation], timeout: 10)
        
        // assert
        XCTAssertEqual(received, LoginError.loginError)
        cancellable.cancel()
    }
}
