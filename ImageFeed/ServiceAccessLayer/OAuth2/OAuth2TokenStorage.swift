//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 02.07.23.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}


