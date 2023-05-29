import UIKit

final class OAuth2Service {
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, UnsplashError>) -> Void) {
        //формируем url
        let url = createURL(code: code)
        //создаем  http запрос (url-request)
        let request = createHTTPRequest(url: url)
        
        //гонка потоков
        assert(Thread.isMainThread)
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
        //создаем задачу (url-session)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Считаю, что использование assertionFailure является возможным, так как крашит приложение только в дебаге, что позволит легче находить ошибки. Для релизной версии есть .failure
            guard let data = data else { assertionFailure("No Data"); completion(.failure(.dataError)); return}
            //если ошибка будет на стороне клиента, а не сервера. В противном случае ошибка будет обработана в Dispatch
            guard error == nil else {assertionFailure("Error from request"); completion(.failure(.errorByClient)); return}
            DispatchQueue.main.async {
                //распарсинг ответа
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let resp = try decoder.decode(UnsplashOAuth2Response.self, from: data)
                            completion(.success(resp.accessToken))
                            self.task = nil
                            if error != nil {
                                self.lastCode = nil
                            }
                        } catch {
                            completion(.failure(.parsingError))
                        }
                    default:
                        do {
                            let resp = try decoder.decode(UnsplashOAuth2ResponseError.self, from: data)
                            completion(.failure(.errorRequest))
                        } catch {
                            completion(.failure(.parsingError))
                        }
                    }
                } else {
                    return
                }
            }
        }
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

