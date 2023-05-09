import UIKit

class OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, UnsplashError>) -> Void){
        //формируем url
        let url = createURL(code: code)
        //создаем  http запрос (url-request)
        let request = createHTTPRequest(url: url)
        //создаем задачу (url-session)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {print("No Data"); return}
            //если ошибка будет на стороне клиента, а не сервера. В противном случае ошибка будет обработана в Dispatch
            guard error == nil else {print("Error = ", error); return}
            print("Data = ", String(data: data, encoding: .utf8))
            
            DispatchQueue.main.async {
                //распарсинг ответа
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        let resp = try! JSONDecoder().decode(UnsplashOAuth2Response.self, from: data)
                        print("Resp = ", resp)
                        completion(.success(resp.access_token))
                    default:
                        let resp = try! JSONDecoder().decode(UnsplashOAuth2ResponseError.self, from: data)
                        completion(.failure(.errorRequest))
                        //обработка ошибки из поступвшего json
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

