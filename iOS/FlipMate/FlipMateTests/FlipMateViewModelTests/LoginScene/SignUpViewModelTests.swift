//
//  SignUpViewModelTests.swift
//  FlipMateTests
//
//  Created by 권승용 on 1/8/24.
//

import Foundation
import XCTest
import Combine
@testable import FlipMate

private enum NicknameStatus {
    static let success = "success"
    static let fail = "fail"
}

private final class ValidateNicknameUseCaseStub: ValidateNicknameUseCase {
    func isNickNameValid(_ nickName: String) -> FlipMate.NickNameValidationState {
        return .valid
    }
}

private final class SetupProfileInfoUseCaseStub: SetupProfileInfoUseCase {
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> FlipMate.UserInfo {
        return UserInfo(name: nickName, profileImageURL: "", email: "")
    }
}

private final class SetupProfileInfoUseCaseDuplicatedStub: SetupProfileInfoUseCase {
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> FlipMate.UserInfo {
        throw APIError.errorResponse(StatusResponseWithErrorDTO(statusCode: 40000, message: "", error: "", path: "", timestamp: ""))
    }
}

private final class SetupProfileInfoUseCaseImageNotSafeStub: SetupProfileInfoUseCase {
    func setupProfileInfo(nickName: String, profileImageData: Data) async throws -> FlipMate.UserInfo {
        throw APIError.errorResponse(StatusResponseWithErrorDTO(statusCode: 40001, message: "", error: "", path: "", timestamp: ""))
    }
}

final class SignUpViewModelTests: XCTestCase {
    private var sut: SignUpViewModelProtocol!
    
    override func setUpWithError() throws {
        sut = SignUpViewModel(
            validateNickNameUseCase: ValidateNicknameUseCaseStub(),
            setupProfileUseCase: SetupProfileInfoUseCaseStub(),
            actions: SignUpViewModelActions(didFinishSignUp: {}))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_닉네임_변경_완료() {
        let expectation = XCTestExpectation()
        var received: NickNameValidationState!
        let cancellable = sut.isValidNickNamePublisher
            .sink { validationState in
                received = validationState
                expectation.fulfill()
            }
        
        sut.nickNameChanged(NicknameStatus.success)
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(received, .valid)
        cancellable.cancel()
    }
    
    func test_로그인_성공() {
        let expectation = XCTestExpectation()
        let cancellable = sut.isSignUpCompletedPublisher
            .sink { () in
                expectation.fulfill()
            }
        
        sut.signUpButtonTapped(userName: "userName", profileImageData: Data())
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(true)
        cancellable.cancel()
    }
    
    func test_로그인_실패_닉네임중복() {
        sut = SignUpViewModel(
            validateNickNameUseCase: ValidateNicknameUseCaseStub(),
            setupProfileUseCase: SetupProfileInfoUseCaseDuplicatedStub(),
            actions: SignUpViewModelActions(didFinishSignUp: {}))
        let expectation = XCTestExpectation()
        var received: NickNameValidationState!
        let cancellable = sut.isValidNickNamePublisher
            .sink { state in
                received = state
                expectation.fulfill()
            }
        
        sut.signUpButtonTapped(userName: "userName", profileImageData: Data())
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(received, .duplicated)
        cancellable.cancel()
    }
    
    func test_로그인_실패_이미지유해() {
        sut = SignUpViewModel(
            validateNickNameUseCase: ValidateNicknameUseCaseStub(),
            setupProfileUseCase: SetupProfileInfoUseCaseImageNotSafeStub(),
            actions: SignUpViewModelActions(didFinishSignUp: {}))
        
        let expectation = XCTestExpectation()
        let cancellable = sut.imageNotSafePublisher
            .sink { () in
                expectation.fulfill()
            }
        
        sut.signUpButtonTapped(userName: "userName", profileImageData: Data())
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(true)
        cancellable.cancel()
    }
}
