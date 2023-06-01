//
//  Profile.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 30.05.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String //"@" + username
    let bio: String //bio
    
    init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
