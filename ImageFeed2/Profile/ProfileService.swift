//
//  ProfileService.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 30.05.2023.
//

import Foundation
//MARK: Надо добавить защиту от гонок
final class ProfileService {
    private var task: URLSessionTask?
    private var lastToken: String?
   
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private init(){}
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, UnsplashError>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastToken != token {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastToken == token {
                return
            }
        }
        lastToken = token
        
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, UnsplashError>) in
            switch result {
            case(.success(let succesResult)):
                self?.profile = self?.converterFromProfileResultToProfile(result: succesResult)
                completion(.success((self?.profile)!))
                self?.task = nil
            default:
                self?.lastToken = nil
                completion(.failure(.parsingError))
                assertionFailure("При запросе данных профиля произошла ошибка")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func converterFromProfileResultToProfile(result: ProfileResult) -> Profile{
        if let bio = result.bio, let lastName = result.lastName {
            return Profile(username: result.username, name: result.firstName + " " + lastName, loginName: "@" + result.username, bio: bio)
        } else if let lastName = result.lastName {
            return Profile(username: result.username, name: result.firstName + " " + lastName, loginName: "@" + result.username, bio: "")
        } else if let bio = result.bio {
            return Profile(username: result.username, name: result.firstName + " ", loginName: "@" + result.username, bio: bio)
        } else {
            return Profile(username: result.username, name: result.firstName + " ", loginName: "@" + result.username, bio: "")
        }
    }
}
