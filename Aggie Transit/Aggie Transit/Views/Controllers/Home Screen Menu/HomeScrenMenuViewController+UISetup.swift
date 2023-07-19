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
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    //MARK: - setup favorites collection view
    func setupFavoritesCollectionView() {
        // init
        favoritesCollectionView = UICollectionView(frame: CGRect(x: 0, y: Int(self.searchBar.frame.maxY) + Int((self.view.layoutMargins.bottom)) , width: Int(self.view.frame.width - (self.view.layoutMargins.left * 2)), height: Int(self.view.frame.height - (self.view.layoutMargins.top + self.searchBar.frame.height))), collectionViewLayout: singleColumnLayout)
        // configure
        if let favoritesCollectionView {
//            // register cells and headers
            favoritesCollectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.id)
            favoritesCollectionView.register(FavoritesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.id)
            // create data source
//            let dataSource = UICollectionViewDiffableDataSource<FavoritesSection, FavoriteLocation>(collectionView: favoritesCollectionView, cellProvider: {
//                collectionView, indexPath, favoriteLocation -> UICollectionViewCell? in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.id, for: indexPath) as! FavoritesCollectionViewCell
//                cell.name = favoriteLocation.name
//                cell.address = favoriteLocation.address
//                return cell
//            })
            // configure collection view and the layout
            favoritesCollectionView.dataSource = self
            favoritesCollectionView.delegate = self
            favoritesCollectionView.backgroundColor = .clear
            favoritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            self.view.addSubview(favoritesCollectionView)
            // constrain
            NSLayoutConstraint.activate([
                favoritesCollectionView.topAnchor.constraint(equalTo: self.searchBar.layoutMarginsGuide.bottomAnchor, constant: 20),
                favoritesCollectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                favoritesCollectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
                favoritesCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
            ])
            // create a snap shot
            var snapshot = NSDiffableDataSourceSnapshot<FavoritesSection, FavoriteLocation>()
            // populate the snap shot
            snapshot.appendSections([.main])
            snapshot.appendItems(sampleData, toSection: .main)
            // apply snapshot
           // dataSource.apply(snapshot, animatingDifferences: true)
            
        }
        
        
    }
}
