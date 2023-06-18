//
//  UserResult.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 04.06.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
