//
//  AuthViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    func switchToTabBarController()
}

class AuthViewController: UIViewController, ProtocolWebViewViewControllerDelegate {
    let segueToWebView = "ShowWebView"
    let oAuth2Service = OAuth2Service()
    var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var splashDelegate: SplashViewController?
        
    override func viewDidLoad() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToWebView {
            let vc = segue.destination as! WebViewViewController
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        splashDelegate?.authViewController(self, didAuthenticateWithCode: code)
        
        oAuth2Service.fetchAuthToken(code: code) { [self] result in
            switch result {
            case.success(let token):
                oAuth2TokenStorage.token = token
                //вызвать switch to tabBar
                splashDelegate?.switchToTabBarController()
                print("Token = ", oAuth2TokenStorage.token)
            case.failure(let error):
                print("Error = ", error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
