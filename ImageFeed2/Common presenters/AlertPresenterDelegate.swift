//
//  AlertPresenterDelegate.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 01.06.2023.
//

import UIKit

protocol AlertPresenterDelegate {
    var delegate: UIViewController? { get set }
    func presentAlert(model: AlertModel)
}
