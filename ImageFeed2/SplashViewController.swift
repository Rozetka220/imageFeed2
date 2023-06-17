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
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    var alertDelegate: AlertPresenterDelegate? = AlertPresenter()
    
    private var logoImageView: UIImageView?
    
    override func viewDidAppear(_ animated: Bool) {
        if checkToken() {
            fetchProfile(token: oAuth2TokenStorage.token!)
        } else {
            var storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertDelegate?.delegate = self
        createSplashScreenView()
    }
    
    private func createSplashScreenView(){
        createLogo()
    }
    
    private func createLogo(){
        logoImageView = UIImageView()
        guard let logoImageView = logoImageView else { assertionFailure("не удалось загрузить логотип"); return}
        logoImageView.image = UIImage(named: "logoUnsplash")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkToken() -> Bool{
        return oAuth2TokenStorage.token != nil
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "tabBarID")
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func presentAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .destructive, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        return alert
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let token):
                    self.oAuth2TokenStorage.token = token
                    self.fetchProfile(token: token)
                    UIBlockingProgressHUD.dismiss()
                case.failure(let error):
                    vc.presentedViewController?.present(self.presentAlert(), animated: true)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func fetchProfile(token: String){
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {print("self = nil!"); return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { [weak self] result in
                        switch result {
                        case .success(let avatarURL):
                            self?.switchToTabBarController()
                        default:
                            assertionFailure("не удалось получить url аватарки в splashVC")
                        }
                    }
                default:
                    self.presentedViewController?.present(self.presentAlert(), animated: true)
                }
            }
        }
    }
}
