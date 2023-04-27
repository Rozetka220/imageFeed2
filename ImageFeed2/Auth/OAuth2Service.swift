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

//    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void){
//        print("FETCH AUTH TOKEN")
//        //Сформировать URL
//        let url = URL(string: "https://unsplash.com/oauth/token")
//        guard let url = url else { print("URL is nil"); return }
//        //Создать HTTP-запрос (URL Request)
//        var request = URLRequest(url: authTokenURL(code: code))
//        request.httpMethod = "POST"
//
//        //let httpPostBody = makeParameters(code: code)
//
//        //сделать как для get
//        //request.httpBody = try! JSONEncoder().encode(httpPostBody)
//
//
//        //хлам
//        //print("HTTP BODY = ", String(data: request.httpBody!, encoding: .utf8))
//
//        //print("HTTP BODY = ", request.httpBody)
//        //Создать задачу (URL Session Task)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {print("NO DATA"); return}
//            guard error == nil else {print("ERROR = ", error?.localizedDescription); return}
//
//            print("Data",data)
//
//            DispatchQueue.main.async {
//                print("ВЫВОДИМ ДАТА")
//                //надо распарсить ответ и закинуть успех в succec и ошибку в failure( Error(error_from_json)
//                print(String(data: data, encoding: .utf8))
//                if let response = response as? HTTPURLResponse {
//                    switch response.statusCode {
//                    case 200..<300:
//                        print("Succes")
//                        completion(.success("Succes"))//но чет другое какой то там токен дропаем
////                    case 300..<400:
////                        print("Redirection")
////                        completion("Redirection")
//                    case 400..<500:
//                        print("Client Error")
//                        //completion(.failure(Error("Error")) //анврапим же сверху, зачем еще раз приходится?
//                    default:
//                        print("Server Error")
//                    }
//
//                }
//            }
//        }
//        task.resume()
//    }
//
//    func makeParameters(code: String) -> POSTparamBearerToken{
//        let constants = Constants()
//        let postParam = POSTparamBearerToken(client_id: constants.accessKey, client_secret: constants.secretKey, redirect_uri: constants.redirectURI, code: code, grant_type: "authorization_code")
//
//        print("PRINT postParam: ", postParam)
//        return postParam
//    }
//
//    func authTokenURL(code: String) -> URL {
//        let constants = Constants()
//        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "?client_id", value: constants.accessKey),
//            URLQueryItem(name: "&&client_secret", value: constants.secretKey),
//            URLQueryItem(name: "&&redirect_uri", value: constants.redirectURI),
//            URLQueryItem(name: "&&code", value: code),
//            URLQueryItem(name: "&&grant_type", value: "authorization_code")
//        ]
//        return urlComponents.url!
//    }
