//
//  POSTparamBearerToken.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 20.04.2023.
//

import Foundation

//MARK: - Структура используется для отправки запроса на сервер Unsplash для получения bearerToken
struct POSTparamBearerToken: Encodable {
    var client_id: String
    var client_secret: String
    var redirect_uri: String
    var code: String
    var grant_type: String
}
