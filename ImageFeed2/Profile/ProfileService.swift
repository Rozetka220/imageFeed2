//
//  ProfileService.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 30.05.2023.
//

import Foundation

final class ProfileService {
   
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
        
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, UnsplashError>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/me")!
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
                            let resp = try JSONDecoder().decode(ProfileResult.self, from: data)
                            let profile2 = self.converterFromProfileResultToProfile(result: resp)
                            self.profile = Profile(username: profile2.username, name: profile2.name, loginName: profile2.loginName, bio: profile2.bio)
                            completion(.success(profile2))
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
        }
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
