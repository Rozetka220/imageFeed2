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

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {

    
    let segueToWebView = "ShowWebView"
    let oAuth2Service = OAuth2Service()
    var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToWebView {
            guard let vc = segue.destination as? WebViewViewController else {return}
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

//
//private func createButton(){
//    comeInButton = UIButton()
//    guard let comeInButton = comeInButton else {assertionFailure("не удалось создать кнопку"); return}
//
//    comeInButton.setTitle("Войти", for: .normal)
//    comeInButton.setTitleColor(UIColor(named: "YP Black (iOS)"), for: .normal)
//    comeInButton.backgroundColor = UIColor(named: "YP White")
//    comeInButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//    comeInButton.layer.cornerRadius = 16
//    comeInButton.addTarget(self, action: #selector(clickedComeInButton(_:)), for: .touchUpInside)
//
//    comeInButton.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(comeInButton)
//
//    NSLayoutConstraint.activate([
//        comeInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//        comeInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//        comeInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
//        comeInButton.heightAnchor.constraint(equalToConstant: 48)
//    ])
//}
