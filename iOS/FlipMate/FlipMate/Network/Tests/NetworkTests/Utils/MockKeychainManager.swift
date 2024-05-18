//
//  File.swift
//  
//
//  Created by 권승용 on 5/17/24.
//

import Foundation
@testable import Core

struct MockKeychainManager: KeychainManageable {
    func saveAccessToken(token: String) throws {
    }
    
    func getAccessToken() throws -> String {
        return ""
    }
    
    func deleteAccessToken() throws {
    }
    
    func saveAppleUserID(id: String) throws {
    }
    
    func getAppleUserID() throws -> String {
        return ""
    }
    
    func deleteAppleUserID() throws {
    }
}
