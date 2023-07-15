//
//  HomeScrenMenuViewController+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit

extension HomeScreenMenuViewController {
    //MARK: - setup self
    func setupSelf()  {
        self.view.isUserInteractionEnabled = true
        self.view.layer.cornerRadius = 15
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    //MARK: - setup search bar
    func setupSearchBar() {
        // setup
        searchBar.placeholder = "Memorial Student Center (MSC)"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.tintColor = .systemBlue
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.textColor = UIColor(named: "textColor")
            searchField.clipsToBounds = true
        }
        // add to view hierarchy
        self.view.addSubview(searchBar)
        // constrain
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: (52 * (self.view.frame.height/812))),
            searchBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor)
        ])
    }
    //MARK: - setup favorites table view
    func setupFavoritesTableView() {
        // configure
        favoritesTableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.id)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.backgroundColor = .clear
        favoritesTableView.separatorStyle = .none
        favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.view.addSubview(favoritesTableView)
        // constrain
        NSLayoutConstraint.activate([
            favoritesTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            favoritesTableView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
