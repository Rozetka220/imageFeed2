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
    
    var alertDelegate: AlertPresenterDelegate? = AlertPresenter()
    
    override func viewDidAppear(_ animated: Bool) {
        if checkToken() {
            performSegue(withIdentifier: "toTabBar", sender: nil)
        } else {
            performSegue(withIdentifier: "goToAuth", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertDelegate?.delegate = self
    }
    
    private func checkToken() -> Bool{
        return oAuth2TokenStorage.token != nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let viewController = navigationController.viewControllers[0] as? AuthViewController {
            viewController.delegate = self
        }
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
        let alert = UIAlertController(title: "Внимание!", message: "Ошибка чтения ответа сервера, повторите попытку позже", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .destructive, handler: { _ in
            self.backToSplashViewController()
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
        vc.oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let token):
                    self.oAuth2TokenStorage.token = token
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case.failure(let error):
                    vc.presentedViewController?.present(self.presentAlert(), animated: true)
                }
            }
        }
    }
}


//попытка сделать через делегат в алертпрезент, но не увенчалась успехом
extension SplashViewController {
    func createAlertText() -> AlertModel {
        let alerModel = AlertModel(title: "Ошибка!",
                                   message: "Ошибка чтения данных с сервера \n повторите попытку позже",
                                   buttonText: "Отмена") { [weak self] _ in
                        //перемещаемся на imageList
            self?.backToSplashViewController()
        }
        return alerModel
    }
}
