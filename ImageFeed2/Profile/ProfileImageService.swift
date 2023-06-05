//
//  ProfileImageService.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 04.06.2023.
//

import Foundation


//MARK: Надо добавить защиту от гонок
final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var token = OAuth2TokenStorage().token //наверное надо выкинуть в синглтон
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, UnsplashError>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/me/users/" + username)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] ( result: Result<UserResult, UnsplashError>) in
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.small
                completion(.success(userResult.profileImage.small)) // зачем я это делаю?
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self?.avatarURL])
            default:
                //по идее ошибка возвращается из дженерика, затем приходит сюда, и отсюда надо выкинуть её в фетс и вынести в splash где и будет алерт
                assertionFailure("При сетевом запросе на получение аватарки произошла ошибка")
            }
        }.resume()
    }
}
