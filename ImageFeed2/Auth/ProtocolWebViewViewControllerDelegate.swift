//
//  ProtocolWebViewViewControllerDelegate.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 19.04.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
