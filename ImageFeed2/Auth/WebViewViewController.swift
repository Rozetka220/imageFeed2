//
//  WebViewViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    weak var delegate : ProtocolWebViewViewControllerDelegate!
    
    let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        super.viewDidLoad()
        codeRequest()
        
    }
    
    private func codeRequest(){
        let constants = Constants()
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: constants.secretKey),
           URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: constants.accessScope)                     //5
         ]
        
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        print("URL = ", url)
    }
}


extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) { //1
                //TODO: process code                     //2
                decisionHandler(.cancel) //3
          } else {
                decisionHandler(.allow) //4
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}
