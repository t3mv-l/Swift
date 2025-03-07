//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Артём on 12.02.2025.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    let searchBar = UISearchBar()
    var websites = ["about:blank", "google.com", "hackingwithswift.com", "apple.com", "youtube.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // MARK: to check the list of cached sites
        let dataStore = WKWebsiteDataStore.default()
        
        let dataTypes: Set<String> = [WKWebsiteDataTypeFetchCache, WKWebsiteDataTypeMemoryCache]
        
        dataStore.fetchDataRecords(ofTypes: dataTypes) { records in
            for record in records {
                print("Cache record: \(record)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search..."
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        self.navigationItem.titleView = searchBar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: websites[0])!
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
            self.webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            DispatchQueue.main.async {
                self.webView.goBack()
                self.updateSearchBarText()
            }
        }
    }
    
    @objc func openTapped() {
        let vc = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            vc.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    func updateSearchBarText() {
        if let currentURL = webView.url?.absoluteString {
            print(currentURL)
            searchBar.text = currentURL != websites[0] ? currentURL : ""
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                self.progressView.progress = Float(self.webView.estimatedProgress)
                self.progressView.isHidden = self.webView.estimatedProgress >= 1.0
            }
        }
    }
}
