//
//  AlertPresenter.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 01.06.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterDelegate {
    weak var delegate: UIViewController?
    
    func presentAlert(model: AlertModel){
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: model.buttonText, style: .destructive, handler: model.completion))
        
        delegate?.present(alert, animated: true)
    }
    
}

