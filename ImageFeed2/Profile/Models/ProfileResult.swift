//
//  ProfileResult.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 30.05.2023.
//

import Foundation

// MARK: структура для парсинга ответа на запрос Get /me
struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

