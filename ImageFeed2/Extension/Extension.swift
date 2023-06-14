//
//  ExtentionURLSession.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 05.06.2023.
//

import Foundation
//MARK: Дженерик для сетевых запросов: авторизация, данные профиля пользователя, аватара профиля пользователя
extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completition: @escaping (Result<T, UnsplashError>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {return completition(.failure(.dataError))}
            guard error == nil  else { return completition(.failure(.errorByClient))}
            guard let response = response else { return completition(.failure(.errorRequest))}
            //по идее, здесь не должно быть главного потока, потому что может парсинг может оказаться очень ресурсозатратным?
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            completition(.success(decodedResponse))
                        } catch {
                            completition(.failure(.parsingError))
                        }
                    default:
                        do {
                            let decodedErrorsResponse = try JSONDecoder().decode(ErrorMessages.self, from: data)
                            for i in decodedErrorsResponse.errors {
                                assertionFailure(i)
                            }
                            completition(.failure(.errorRequest))
                        } catch {
                            completition(.failure(.errorRequest))
                        }
                    }
                } else {
                    completition(.failure(.errorRequest))
                }
            }
        })
        return task
    }
}
