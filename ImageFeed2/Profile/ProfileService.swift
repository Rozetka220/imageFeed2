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
        
        //тут как будто происходить повторная проверка на те же ошибки, что и ранне. По идее все ошибки должны сотаться в generic и в splash можно передовать просто Profile без error?
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, UnsplashError>) in
            switch result {
            case(.success(let succesResult)):
                self?.profile = self?.converterFromProfileResultToProfile(result: succesResult)
                completion(.success((self?.profile)!))
                self?.task = nil
            default:
                self?.lastToken = nil
                assertionFailure("При запросе данных профиля произошла ошибка")
                completion(.failure(.parsingError))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func converterFromProfileResultToProfile(result: ProfileResult) -> Profile{
        if let bio = result.bio {
            return Profile(username: result.username, name: result.firstName + " " + result.lastName, loginName: "@" + result.username, bio: bio)
        } else {
            return Profile(username: result.username, name: result.firstName + " " + result.lastName, loginName: "@" + result.username, bio: "")
        }
    }
}
