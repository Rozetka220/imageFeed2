//
//  UnsplashOAuth2ResponseError.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 23.04.2023.
//

import Foundation

//MARK: - Структура используется для обработки ошибок от сервера Unsplash
struct UnsplashOAuth2ResponseError: Decodable {
    let error: String
    let error_description: String
}