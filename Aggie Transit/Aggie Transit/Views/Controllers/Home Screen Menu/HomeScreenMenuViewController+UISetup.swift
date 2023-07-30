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
        self.view.backgroundColor = .white
        // configure sheet presentation
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: UISheetPresentationController.Detent.Identifier("small"), resolver: { context in
                    180
                }),
                .medium(),
                .large()
            ]
            
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            isModalInPresentation = true
        }
    }
    //MARK: - setup search bar
    func setupSearchBar() {
        // setup
        searchBar.placeholder = "Memorial Student Center (MSC)"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
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
            searchBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20)
        ])
    }
    //MARK: - setup favorites/recents collection view
    func setupDefaultCollectionView() {
        // init
        defaultCollectionView = UICollectionView(frame: CGRect(x: 0, y: Int(self.searchBar.frame.maxY) + Int((self.view.layoutMargins.bottom)) , width: Int(self.view.frame.width - (self.view.layoutMargins.left * 2)), height: Int(self.view.frame.height - (self.view.layoutMargins.top + self.searchBar.frame.height))), collectionViewLayout: singleColumnLayout)
        // configure
        if let defaultCollectionView {
//            // register cells and headers
            defaultCollectionView.register(HomeScreenMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeScreenMenuCollectionViewCell.id)
            defaultCollectionView.register(HomeScreenMenuCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeScreenMenuCollectionHeaderView.id)
            defaultCollectionView.register(HomeScreenMenuCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeScreenMenuCollectionFooterView.id)
            // configure collection view and the layout
            defaultCollectionView.dataSource = self
            defaultCollectionView.delegate = self
            defaultCollectionView.backgroundColor = .clear
            defaultCollectionView.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            self.view.addSubview(defaultCollectionView)
            // constrain
            NSLayoutConstraint.activate([
                defaultCollectionView.topAnchor.constraint(equalTo: self.searchBar.layoutMarginsGuide.bottomAnchor, constant: 20),
                defaultCollectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                defaultCollectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
                defaultCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
            ])
            
        }
    }
    //MARK: - setup search results collection view
    func setupSearchCollectionView() {
        // init
        searchCollectionView = UICollectionView(frame: CGRect(x: 0, y: Int(self.searchBar.frame.maxY) + Int((self.view.layoutMargins.bottom)) , width: Int(self.view.frame.width - (self.view.layoutMargins.left * 2)), height: Int(self.view.frame.height - (self.view.layoutMargins.top + self.searchBar.frame.height))), collectionViewLayout: singleColumnLayout)
        // configure
        if let searchCollectionView {
            searchCollectionView.allowsSelection = true
            searchCollectionView.allowsMultipleSelection = false
            // register cell
            searchCollectionView.register(HomeScreenMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeScreenMenuCollectionViewCell.id)
            searchCollectionView.register(HomeScreenMenuCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeScreenMenuCollectionHeaderView.id)
            searchCollectionView.register(HomeScreenMenuCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeScreenMenuCollectionFooterView.id)
            // configure layout
            searchCollectionView.dataSource = self
            searchCollectionView.delegate = self
            searchCollectionView.backgroundColor = .clear
            searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            self.view.addSubview(searchCollectionView)
            // constrain
            NSLayoutConstraint.activate([
                searchCollectionView.topAnchor.constraint(equalTo: self.searchBar.layoutMarginsGuide.bottomAnchor, constant: 20),
                searchCollectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                searchCollectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
                searchCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
            ])
            
        }
    }
}
