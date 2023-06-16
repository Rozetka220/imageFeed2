//
//  AlertModel.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 01.06.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (UIAlertAction) -> Void
}
