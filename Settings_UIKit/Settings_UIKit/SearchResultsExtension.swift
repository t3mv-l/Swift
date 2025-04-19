//
//  SearchResultsExtension.swift
//  Settings_UIKit
//
//  Created by Артём on 19.04.2025.
//

import UIKit

extension MyViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredSections.removeAll()
            tableView.reloadData()
            return
        }
        
        filteredSections = allSections.filter { section in
            return section.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
