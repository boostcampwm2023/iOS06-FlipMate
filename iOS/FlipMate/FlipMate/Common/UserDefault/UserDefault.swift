//
//  UserDefault.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/01.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let subject = PassthroughSubject<T, Never>()
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            subject.send(newValue)
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    var projectedValue: AnyPublisher<T, Never> {
        return subject.eraseToAnyPublisher()
    }
}
