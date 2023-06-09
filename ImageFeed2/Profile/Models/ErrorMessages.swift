//
//  ProfileImagesServiceError.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 08.06.2023.
//

import Foundation

struct ErrorMessages: Decodable, Error {
    let errors: [String]
}
