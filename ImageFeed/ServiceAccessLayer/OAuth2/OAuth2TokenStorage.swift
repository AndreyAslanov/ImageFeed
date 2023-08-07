//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 02.07.23.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    private enum Keys: String {
        case token
    }

    static let shared = OAuth2TokenStorage()

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    func clean() {
        KeychainWrapper.standard.removeAllKeys()
    }
}

