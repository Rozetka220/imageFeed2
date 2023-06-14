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
        print("Splash хочется показаться debug")
        if checkToken() {
            print("токен есть debug")
            fetchProfile(token: oAuth2TokenStorage.token!)
           // switchToTabBarController()
//            let storyboard = UIStoryboard(name: "Main", bundle: .main)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarID")
//            viewController.modalPresentationStyle = .fullScreen
//            present(viewController, animated: true)
        } else {
            print("токена нет debug")
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
    
    private func presentAlert( completion: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: "Внимание!", message: "Ошибка чтения ответа сервера, повторите попытку позже", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .destructive, handler: { [weak self] _ in
            //self.backToSplashViewController()
            completion()
        }))
        return alert
    }
    
    private func backToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let splashViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "splashViewControllerID")
        
        window.rootViewController = splashViewController
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        print("Получение токена debug")
        vc.oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let token):
                    self.oAuth2TokenStorage.token = token
                    print("Токен получен успешно debug: ", token)
                    self.fetchProfile(token: token)
                    UIBlockingProgressHUD.dismiss()
                    //self.switchToTabBarController()
                case.failure(let error):
                    vc.presentedViewController?.present(self.presentAlert(completion: {
                        self.backToSplashViewController()
                    }), animated: true)
                }
            }
        }
    }
    
    private func fetchProfile(token: String){
        print("Пошел запрос данных профиля debug")
        profileService.fetchProfile(token) { [weak self] result in
            print("Данные профиля получены, идет проверка self debug, result = ", result)
            guard let self = self else {print("self = nil!"); return }
            print("self not nil debug")
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    print("Начался запрос аватарки debug")
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { [weak self] result in
                        switch result {
                        case .success(let avatarURL):
                            self?.switchToTabBarController()
                            print("Был получен avatarURL")
                        default:
                            assertionFailure("наверное тут должна быть заглушка аватарки")
                        }
                    }
                default:
                    self.presentedViewController?.present(self.presentAlert(completion: {
                    }), animated: true)
                }
            }
        }
    }
}


//попытка сделать через делегат в алертпрезент, но не увенчалась успехом
extension SplashViewController {
    func createAlertText(title: String, message: String, buttonText: String) -> AlertModel {
        let alerModel = AlertModel(title: title, //"Ошибка!",
                                   message: message, // "Не удалось загрузить профиль \n повторите попытку позже",
                                   buttonText: buttonText) { [weak self] _ in
            self?.backToSplashViewController()
        }
        return alerModel
    }
}
