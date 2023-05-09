//
//  SplashViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 27.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    weak var delegate: AuthViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        if checkToken() {
            performSegue(withIdentifier: "toTabBar", sender: nil)
        } else {
            performSegue(withIdentifier: "goToAuth", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToAuth" else { return  super.prepare(for: segue, sender: sender) }
        guard let destination = segue.destination as? AuthViewController else { return }
        destination.splashDelegate = self
    }
    //в учебнике данный метод как private, но как я тогда вызову этот метод снаружи?
    internal func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "tabBarID")

        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
    }
}
