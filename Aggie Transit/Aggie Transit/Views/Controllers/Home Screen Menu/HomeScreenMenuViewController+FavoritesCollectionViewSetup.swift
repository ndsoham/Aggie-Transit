//
//  HomeScreenMenuViewController+FavoritesTableViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit
//MARK: - sample data
let sampleData: [FavoriteLocation] = [
    FavoriteLocation(id: 1, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 2, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 3, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 4, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 5, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 6, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 7, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 8, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 9, name: "Kings Cross Underground Station", address: "New York"),
    FavoriteLocation(id: 10, name: "Kings Cross Underground Station", address: "New York")
]
//MARK: - struct for collection view diffable data source section identifier
enum FavoritesSection: Hashable {
    case main
}
//MARK: - struct for collection view diffable data source cell identifier
struct FavoriteLocation: Hashable, Identifiable {
    var id: Int
    var name: String
    var address: String
}
//MARK: - collection view methods
extension HomeScreenMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   // return number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    // return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.id, for: indexPath) as! FavoritesCollectionViewCell
        cell.address = sampleData[indexPath.row].address
        cell.name = sampleData[indexPath.row].name
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        return cell
    }
    // return header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // return a header
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.id, for: indexPath) as! FavoritesHeaderView
            if (indexPath.section == 0){
                header.headerName = "Favorite Locations"
            } else if (indexPath.section == 1) {
                header.headerName = "Recent"
            }
            return header
        }
        // return a footer
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FavoritesFooterView.id, for: indexPath) as! FavoritesFooterView
        if (indexPath.section == 0) {
            footer.footerName = "Favorite"
        } else {
            footer.footerName = "Recent"
        }
        return footer
        
    }
}
//MARK: - layout delegate and methods
extension HomeScreenMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 40)
    }
}
