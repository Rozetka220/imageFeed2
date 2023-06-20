//
//  ImagesListService.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.06.2023.
//

import UIKit

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    var currentTask: URLSessionTask?
    private var token = OAuth2TokenStorage().token
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private lazy var dateFormatter: DateFormatter? = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard let token = token else { assertionFailure("В хранилище не оказалось токена"); return}
        
        var nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        if currentTask != nil && lastLoadedPage != nextPage {
            return
        }
        
        
        let url = createURLWithGetParams(String(nextPage))
        print("Url = ",url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], UnsplashError>) in
            print("Self url = ", url)
            guard let self = self else {assertionFailure("self = nil"); return}
            switch result {
            case(.success(let succesResult)):
                for photo in succesResult {
                    self.photos.append(self.convertFromPhotoResultToPhoto(result: photo))
                    print("получен экземпляр фото: ", photo.id)
                }
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self, userInfo: ["Photo": self.photos])
                self.lastLoadedPage = nextPage
                self.currentTask = nil
            case(.failure(.parsingError)):
                assertionFailure("Произошла ошибка парсинга")
            default:
                //self.lastLoadedPage = nil
                assertionFailure("Произошла ошибка получения данных с сервера")
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func createURLWithGetParams(_ page: String) -> URL{
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "latest")
        ]
        
        return urlComponents.url!
    }
    
    private func convertFromPhotoResultToPhoto(result: PhotoResult) -> Photo{
        if let welcomeDescription = result.description {
            return Photo(id: result.id, size: CGSizeMake(CGFloat(result.width), CGFloat(result.height)), createdAt: dateFromString(result.createdAt), welcomeDescription: welcomeDescription, thumbImageURL: result.urls.thumb, largeImageURL: result.urls.full, isLiked: result.likedByUser)
        } else {
            return Photo(id: result.id, size: CGSizeMake(CGFloat(result.width), CGFloat(result.height)), createdAt: dateFromString(result.createdAt), welcomeDescription: "", thumbImageURL: result.urls.thumb, largeImageURL: result.urls.full, isLiked: result.likedByUser)
        }
    }
    
    private func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { assertionFailure("Дата фотки не получена с сервака")  ;return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
}
