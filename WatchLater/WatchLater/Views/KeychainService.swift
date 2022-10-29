//
//  KeychainService.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 17.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol KeychainProtocol {
    func set(value: TokenDto) throws
    func get() -> TokenDto?
}

enum KeychainError: String, LocalizedError {
    case errorUpdateCode = "Unsuccessful update"
    case errorAddCode = "Unsuccessful save"
}

class KeychainService: KeychainProtocol {
    
    private let account = "com.watchlater.example"
    private let service = "token"
    
    init() {}
    
    init(value: TokenDto) {
        do {
            try set(value: value)
        } catch {
            print(error)
        }
    }
    
    func set(value: TokenDto) throws {
        do {
            let data = try JSONEncoder().encode(value)
            if get() != nil {
                let updateQuery = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                   kSecAttrAccount: account] as CFDictionary
                
                let updateBody = [kSecValueData: data] as CFDictionary
                let resultOfUpdate = SecItemUpdate(updateQuery, updateBody)
                if resultOfUpdate != errSecSuccess {
                    throw KeychainError.errorUpdateCode
                }
            } else {
                let addQuery = [kSecValueData: data,
                                kSecClass: kSecClassGenericPassword,
                                kSecAttrService: service,
                                kSecAttrAccount: account] as CFDictionary
                let resultOfAdd = SecItemAdd(addQuery, nil)
                
                if resultOfAdd != errSecSuccess {
                    throw KeychainError.errorAddCode
                }
            }
        } catch {
            print("exception during set tokenDto in keychain")
        }
    }
    
    func get() -> TokenDto? {
        let getQuery = [kSecClass: kSecClassGenericPassword,
                        kSecAttrService: service,
                        kSecAttrAccount: account,
                        kSecReturnData: true] as CFDictionary
        var result: AnyObject?
        SecItemCopyMatching(getQuery, &result)
        do {
            let data = try JSONDecoder().decode(TokenDto.self, from: result as? Data ?? Data())
            return data
        } catch {
            print("exception during get data from keychain")
        }
        return nil
    }
}
