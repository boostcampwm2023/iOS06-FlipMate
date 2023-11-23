import Foundation

final class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case noToken
        case unknown(OSStatus)
    }
    
    private static let serviceName = "FlipMate"
    
    static func saveAccessToken(token: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecValueData as String: token.data(using: .utf8)! as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func getAccessToken() throws -> String {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.noToken
        }
        
        guard let tokenData = result as? Data, let token = String(data: tokenData, encoding: .utf8) else {
            throw KeychainError.noToken
        }
        
        return token
    }
    
    static func deleteAccessToken() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject
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
