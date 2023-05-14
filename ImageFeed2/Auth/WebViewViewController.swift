//
//  WebViewViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 18.04.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    @IBOutlet private weak var progressView: UIProgressView!
    
    weak var delegate : ProtocolWebViewViewControllerDelegate!
    
    let constants = Constants()
   // let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        super.viewDidLoad()
        codeRequest()
    }
    
    private func codeRequest(){
        var urlComponents = URLComponents(string: constants.unsplashAuthorizeURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: constants.accessScope)
         ]
        
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) {
             delegate.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
          } else {
                decisionHandler(.allow)
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            print("CodeItem", codeItem)
            return codeItem.value
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
