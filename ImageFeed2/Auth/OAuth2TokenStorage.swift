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
            if let data = UserDefaults.standard.string(forKey: "bearerToken") {
                return data
            } else {
                return ""
            }
        } set {
            UserDefaults.standard.set(newValue, forKey: "bearerToken")
        }
    }
}
