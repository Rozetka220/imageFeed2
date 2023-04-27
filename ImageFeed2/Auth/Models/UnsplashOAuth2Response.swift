//
//  UnsplashOAuth2Response.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 23.04.2023.
//

import Foundation

//MARK: - Структура используется для обработки успешного ответа от Unsplush на запрос bearerToken
struct UnsplashOAuth2Response: Decodable {
       let access_token: String
       let token_type: String
       let scope: String
       let created_at: Int
}
