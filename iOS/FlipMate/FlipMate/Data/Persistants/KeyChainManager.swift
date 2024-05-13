import Foundation

protocol KeychainManageable {
    func saveAccessToken(token: String) throws
    func getAccessToken() throws -> String
    func deleteAccessToken() throws
    func saveAppleUserID(id: String) throws
    func getAppleUserID() throws -> String
    func deleteAppleUserID() throws
}

enum KeychainError: Error {
    case duplicateEntry
    case noToken
    case unknown(OSStatus)
}

final class KeychainManager: KeychainManageable {
    enum ServiceName {
        static let flipMate = "FlipMate"
        static let appleLogin = "AppleLogin"
    }
    
    func saveAccessToken(token: String) throws {
        guard let tokenData = token.data(using: .utf8) else {
            throw KeychainError.noToken
        }
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.flipMate as AnyObject,
            kSecValueData as String: tokenData as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func getAccessToken() throws -> String {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.flipMate as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.noToken
        }
        
        guard let tokenData = result as? Data else {
            throw KeychainError.noToken
        }
        let token = String(decoding: tokenData, as: UTF8.self)
        
        return token
    }
    
    func deleteAccessToken() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.flipMate as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noToken
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func saveAppleUserID(id: String) throws {
        guard let idData = id.data(using: .utf8) else {
            throw KeychainError.noToken
        }
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.appleLogin as AnyObject,
            kSecValueData as String: idData as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func getAppleUserID() throws -> String {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.appleLogin as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.noToken
        }
        
        guard let idData = result as? Data else {
            throw KeychainError.noToken
        }
        
        let id = String(decoding: idData, as: UTF8.self)
        
        return id
    }
    
    func deleteAppleUserID() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ServiceName.appleLogin as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noToken
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
}
