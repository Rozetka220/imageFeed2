//
//  SplashViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 27.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        if checkToken() {
            performSegue(withIdentifier: "toTabBar", sender: nil)
        } else {
            performSegue(withIdentifier: "goToAuth", sender: nil)
        }
    }
    
    private func checkToken() -> Bool{
        if oAuth2TokenStorage.token != "" {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let viewController = navigationController.viewControllers[0] as? AuthViewController {
            viewController.splashDelegate = self
        }
//
//        guard segue.identifier == "goToAuth" else { return  super.prepare(for: segue, sender: sender) }
//        guard let destination = segue.destination as? AuthViewController else { return }
//        destination.splashDelegate = self
        
    }
    //в учебнике данный метод как private, но как я тогда вызову этот метод снаружи?
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "tabBarID")

        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let token):
                //зачем здесь необходимо использовать self?
                self.oAuth2TokenStorage.token = token
                self.switchToTabBarController()
            case.failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
