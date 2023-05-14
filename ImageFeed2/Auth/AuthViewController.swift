//
//  AuthViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController, ProtocolWebViewViewControllerDelegate {
    let segueToWebView = "ShowWebView"
    let oAuth2Service = OAuth2Service()
    var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var splashDelegate: SplashViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: Не рекомендую использовать принудительное приведение типов, лучше сделать проверку через guard let
        if segue.identifier == segueToWebView {
            let vc = segue.destination as! WebViewViewController
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        splashDelegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
