import UIKit

final class OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, UnsplashError>) -> Void) {
        //формируем url
        let url = createURL(code: code)
        //создаем  http запрос (url-request)
        let request = createHTTPRequest(url: url)
        //создаем задачу (url-session)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { assertionFailure("No Data"); return}
            //если ошибка будет на стороне клиента, а не сервера. В противном случае ошибка будет обработана в Dispatch
            guard error == nil else {assertionFailure("Error from request"); return}
            
            DispatchQueue.main.async {
                //распарсинг ответа
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let resp = try JSONDecoder().decode(UnsplashOAuth2Response.self, from: data)
                            completion(.success(resp.access_token))
                        } catch {
                            assertionFailure("Произошла ошибка при обработке полученного от сервера ответа с кодом 200..<300")
                        }
                    default:
                        do {
                            let resp = try JSONDecoder().decode(UnsplashOAuth2ResponseError.self, from: data)
                            completion(.failure(.errorRequest))
                        } catch {
                            assertionFailure("Произошла ошибка при обработке полученного от сервера ответа с кодом 300..<600")
                        }
                    }
                } else {
                    return
                }
            }
            
        }
        task.resume()
    }
    
    func createURL(code: String)->URL{
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

