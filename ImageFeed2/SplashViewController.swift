//
//  SplashViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 27.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        if checkToken() {
            //кидаем на галерею
        } else {
            //кидаем на авторизацию
        }
    }
    
    private func checkToken() -> Bool{
        let oAuth2TokenStorage = OAuth2TokenStorage()
        if oAuth2TokenStorage.token != "" {
            return true
        } else {
            return false
        }
    }
}
