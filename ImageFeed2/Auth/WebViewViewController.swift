//
//  WebViewViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var progressView: UIProgressView!
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
            URLQueryItem(name: "redirect_uri", value: constants.redirectURI),
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
        print("ты вызываешься или нет")
         if let code = code(from: navigationAction) { //1
                //TODO: process code                     //2
             print("эу, эээ")
             delegate.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel) //3
          } else {
                print("Код оказался пустым")
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
            print("CodeItem", codeItem)
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}

extension WebViewViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
