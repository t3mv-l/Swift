//
//  WKND_Extension.swift
//  EasyBrowser
//
//  Created by Артём on 07.03.2025.
//

import UIKit
import WebKit

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateSearchBarText()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.3) {
                self.progressView.alpha = 0
            } completion: { _ in
                self.progressView.isHidden = true
                self.progressView.alpha = 1
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
