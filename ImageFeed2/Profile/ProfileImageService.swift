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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return completion(.failure(.dataError))}
            guard error == nil  else { return completion(.failure(.errorByClient))}
            guard let response = response else { return completion(.failure(.errorRequest))}
            
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let resp = try JSONDecoder().decode(ProfileImage.self, from: data)
                            self.avatarURL = resp.small
                            completion(.success(resp.small))
                            NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self.avatarURL])
                        } catch {
                            completion(.failure(.parsingError))
                        }
                    default:
                        completion(.failure(.errorRequest))
                    }
                } else {
                    completion(.failure(.errorRequest))
                }
            }
        }.resume()
    }
    
    
}
