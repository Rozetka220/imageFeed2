//
//  UnsplashError.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 23.04.2023.
//

import Foundation
//MARK: - Используется для обрабоки ошибок в замыкании при запросе bearerToken
enum UnsplashError: Error {
    case errorRequest
    case parsingError
}
