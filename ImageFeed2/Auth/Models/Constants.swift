//
//  Constants.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import Foundation

//MARK: - Структура данных, выданных Unsplash при регистрации приложения
struct Constants {
    let accessKey = "_aGxZoR4YLyuXvZGKijjU6qYtAstJm0xvmNZIUXffmA" //client_id
    let secretKey = "YSz3hJBNjhwhvyr2GfQPGrKeKZsm-6Z6NVU_mRxupLk"
    let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    let accessScope = "public+read_user+write_likes"
    let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
