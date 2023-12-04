//
//  MockFriendUseCase.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/29.
//

import Foundation
import Combine

enum ResponseType {
    case success
    case failure
}

final class MockFriendUseCase: FriendUseCase {
    private var followSubject = CurrentValueSubject<String, NetworkError>("success")
    private var unfollowSubject = CurrentValueSubject<String, NetworkError>("success")
    private var searchSubject = CurrentValueSubject<String?, NetworkError>("https://flipmate.site:3000")
    private var chartSubject = CurrentValueSubject<SocialChart, NetworkError>(SocialChart(myData: [], friendData: [], primaryCategory: nil))
    
    private var type: ResponseType
    
    init(type: ResponseType) {
        self.type = type
    }
    
    func changeType(type: ResponseType) {
        self.type = type
    }
    
    func follow(at nickname: String) -> AnyPublisher<String, NetworkError> {
        if type == .failure {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
         
        return followSubject.eraseToAnyPublisher()
    }
    
    func unfollow(at id: Int) -> AnyPublisher<String, NetworkError> {
        if type == .failure {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
        
        return unfollowSubject.eraseToAnyPublisher()
    }
    
    func search(at nickname: String) -> AnyPublisher<String?, NetworkError> {
        if type == .failure {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
        return searchSubject.eraseToAnyPublisher()
    }
    
    func loadChart(at id: Int) -> AnyPublisher<SocialChart, NetworkError> {
        if type == .failure {
            return Fail(error: NetworkError.statusCodeError).eraseToAnyPublisher()
        }
        
        return chartSubject.eraseToAnyPublisher()
    }
}

