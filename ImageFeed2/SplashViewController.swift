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
        if oAuth2TokenStorage.token != nil {
            return true
        } else {
            return false
        }
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
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let token):
                    self.oAuth2TokenStorage.token = token
                    self.switchToTabBarController()
                case.failure(let error):
                    //вывести алерт с ошибкой
                    print("alert")
//                    let alert = UIAlertController(title: "Внимание!", message: "Ошбика чтения ответа сервера \(error.localizedDescription)", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .destructive, handler: { _ in
//                        NSLog("The \"OK\" alert occured.")
//                    }))
//                    self.present(alert, animated: true, completion: nil)
  
                 //   Вариант от chatGPT
                    
                    
//                    if let topController = UIApplication.shared.windows.filter ({$0.isKeyWindow}).first?.rootViewController {
//                        let alertController = UIAlertController(title: "Заголовок", message: "Сообщение", preferredStyle: .alert)
//                        // здесь вы можете добавить действия для вашего UIAlertController
//                        topController.present(alertController, animated: true, completion: nil)
//                    }

                    
                }
            }
        }
    }
}
