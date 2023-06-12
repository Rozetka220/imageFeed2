import UIKit

final class OAuth2Service {
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, UnsplashError>) -> Void) {
        assert(Thread.isMainThread)
        
        //формируем url
        let url = createURL(code: code)
        //создаем  http запрос (url-request)
        let request = createHTTPRequest(url: url)
        let session = URLSession.shared
        //гонка потоков
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
        lastCode = code
        //xcode рекомендует дописать тут void, не совсем понимаю зачем (не понятным образом это решилось)
        let task = session.objectTask(for: request) { [weak self] (result: Result<UnsplashOAuth2Response, UnsplashError>) in
            switch result {
            case .success(let result):
                completion(.success(result.accessToken))
                self?.task = nil
            default:
                self?.lastCode = nil
                completion(.failure(.errorRequest))
                assertionFailure("Не удалось загрузить токен в OAuth2Service посредством использования generic")
            }
        }
        //почему то теперь таск - это Void и просто так приравнять нельзя. не оченm понимаю, почему в предыдущем варианте он был не void (непонятным образом решилось)
        self.task = task
        task.resume()
        
    }
    
    func createURL(code: String) -> URL{
        let constants = Constants()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.accessKey),
            URLQueryItem(name: "client_secret", value: constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        print("urlComponents = ", urlComponents)
        return urlComponents.url!
    }
    func createHTTPRequest(url: URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

