//
//  ProfileDataStorage.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 04.06.2023.
//

import Foundation


//MARK: используется для сохранения данных профиля, которые были получены в SplashView для дальнейшего отображения их в профиле
class ProfileDataStorage {
    var profileName: String? {
        get {
            UserDefaults.standard.string(forKey: "profileName")
        } set {
            UserDefaults.standard.set(newValue, forKey: "profileName")
        }
    }
    
    var profileLoginName: String? {
        get {
            UserDefaults.standard.string(forKey: "profileLoginName")
        } set {
            UserDefaults.standard.set(newValue, forKey: "profileLoginName")
        }
    }
    
    var profileBio: String? {
        get {
            UserDefaults.standard.string(forKey: "profileBio")
        } set {
            UserDefaults.standard.set(newValue, forKey: "profileBio")
        }
    }
}
