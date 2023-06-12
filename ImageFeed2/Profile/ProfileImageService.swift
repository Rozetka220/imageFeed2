//
//  ProfileImageService.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 04.06.2023.
//

import Foundation


//MARK: Надо добавить защиту от гонок
final class ProfileImageService {
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var token: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, UnsplashError>) -> Void) {
        assert(Thread.isMainThread)
        token = OAuth2TokenStorage().token!
        if task != nil {
            if lastUsername != username {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastUsername == username {
                return
            }
        }
        lastUsername = username
        
        print("Запустился метод получения картинки debug")
        let url = URL(string: "https://api.unsplash.com/users/" + username)!
        var request = URLRequest(url: url)
        guard let token = token else {return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        print("начинается запуск задачи запроса url аватарки debug")
        let task = session.objectTask(for: request) { [weak self] ( result: Result<UserResult, UnsplashError>) in
            print("запуск задачи запроса url аватарки завершился debug")
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.small
                print("avatarURL = ", self?.avatarURL)
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self?.avatarURL])
                completion(.success(userResult.profileImage.small)) // зачем я это делаю?
                self?.task = nil
            default:
                //по идее ошибка возвращается из дженерика, затем приходит сюда, и отсюда надо выкинуть её в фетс и вынести в splash где и будет алерт
                self?.lastUsername = nil
                completion(.failure(.errorRequest))
                assertionFailure("При сетевом запросе на получение аватарки произошла ошибка")
            }
        }
        self.task = task
        task.resume()
    }
}
