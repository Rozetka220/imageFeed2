//
//  OAuth2TokenStorage.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 23.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
//    var token: String?  {
//        get {
//           UserDefaults.standard.string(forKey: "bearerToken")
//        } set {
//            UserDefaults.standard.set(newValue, forKey: "bearerToken")
//        }
//    }

    
    var token: String? {
        get {
            if let token = KeychainWrapper.standard.string(forKey: "bearerToken") {
                return token
            } else {
                return nil
            }
        } set {
            let token = newValue
            let isSuccess = KeychainWrapper.standard.set(token!, forKey: "bearerToken")
            guard isSuccess else {
                assertionFailure("Вместо токена прилетел nil")
                return
            }
        }
    }
    
    
}
