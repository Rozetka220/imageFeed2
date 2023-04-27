//
//  OAuth2TokenStorage.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 23.04.2023.
//

import Foundation

class OAuth2TokenStorage {
    var token: String  {
        get {
            return UserDefaults.standard.string(forKey: "bearerToken")!
        } set {
            UserDefaults.standard.set(newValue, forKey: "bearerToken")
        }
    }
}
