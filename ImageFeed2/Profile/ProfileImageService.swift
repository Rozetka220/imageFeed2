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
        
        let url = URL(string: "https://api.unsplash.com/users/" + username)!
        var request = URLRequest(url: url)
        guard let token = token else {return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] ( result: Result<UserResult, UnsplashError>) in
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.small
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self?.avatarURL])
                completion(.success(userResult.profileImage.small))
                self?.task = nil
            default:
                self?.lastUsername = nil
                completion(.failure(.errorRequest))
                assertionFailure("При сетевом запросе на получение аватарки произошла ошибка")
            }
        }
        self.task = task
        task.resume()
    }
}
