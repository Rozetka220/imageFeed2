//
//  PhotoResult.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.06.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt, updatedAt: String?
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult: Codable {
    let raw, full, regular, small: String
    let thumb: String
}




