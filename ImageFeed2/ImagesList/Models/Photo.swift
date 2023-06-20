//
//  Photos.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.06.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date? //убрал опционал Зачем он?
    let welcomeDescription: String? //убрал опционал Зачем он?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
