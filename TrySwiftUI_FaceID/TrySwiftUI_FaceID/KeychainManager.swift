//
//  KeychainManager.swift
//  TrySwiftUI_FaceID
//
//  Created by Артём on 10.04.2026.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    private let service = "com.artem.TrySwiftUI_FaceID"
    private let account = "passcode"
    
    private init() {}
    
    func savePasscode(_ passcode: String) -> Bool {
        guard let data = passcode.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        return SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess
    }
    
    func getPasscode() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data, let passcode = String(data: data, encoding: .utf8) else { return nil }
        
        return passcode
    }
    
    func hasPasscode() -> Bool {
        return getPasscode() != nil
    }
    
    func deletePasscode() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
