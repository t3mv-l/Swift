//
//  UISBD_Extension.swift
//  EasyBrowser
//
//  Created by Артём on 07.03.2025.
//

import UIKit

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else { return }
        
        var urlString = searchText
        
        if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
            let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString = "https://www.google.com/search?q=" + encodedSearchText
        }
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
}
