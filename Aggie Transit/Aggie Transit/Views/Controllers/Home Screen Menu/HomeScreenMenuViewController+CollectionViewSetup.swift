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
    FavoriteLocation(id: 3, name: "Kings Cross Underground Station", address: "New York")
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
//MARK: - collection view data source/ delegate methods
extension HomeScreenMenuViewController: UICollectionViewDataSource{
   // return number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchCollectionView {
            return searchCompleterResults.count
        }
        if section == 0 {
            return 3
        } else if section == 1, let _ = recentLocations {
            return 3
        }
        return 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == searchCollectionView{
            return 1
        }
        return 2
    }
    // return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenMenuCollectionViewCell.id, for: indexPath) as! HomeScreenMenuCollectionViewCell
        if collectionView == searchCollectionView {
            cell.address = searchCompleterResults[indexPath.row].address
            cell.name = searchCompleterResults[indexPath.row].name
            if (cell.address == "Search Nearby") {
                cell.iconTintColor = .darkGray
                cell.icon = UIImage(systemName: "magnifyingglass.circle.fill")
            } else {
                cell.iconTintColor = .red
                cell.icon = UIImage(systemName: "mappin.circle.fill")
            }
        } else {
            if indexPath.section == 0 {
                cell.address = sampleData[indexPath.row].address
                cell.name = sampleData[indexPath.row].name
                cell.iconTintColor = .darkGray
                cell.icon = UIImage(systemName: "mappin.circle.fill")
            } else if indexPath.section == 1,  let recentLocations {
                cell.address = recentLocations[indexPath.row].address
                cell.name = recentLocations[indexPath.row].name
                cell.iconTintColor = .darkGray
                cell.icon = UIImage(systemName: "mappin.circle.fill")
            }
        }
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        return cell
    }
    // return header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // return a header
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeScreenMenuCollectionHeaderView.id, for: indexPath) as! HomeScreenMenuCollectionHeaderView
            if (indexPath.section == 0){
                header.headerName = "Favorite Locations"
            } else if (indexPath.section == 1) {
                header.headerName = "Recent Locations"
            }
            return header
        }
        // return a footer
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeScreenMenuCollectionFooterView.id, for: indexPath) as! HomeScreenMenuCollectionFooterView
        if (indexPath.section == 0) {
            footer.footerName = "Favorite"
        } else {
            footer.footerName = "Recent"
        }
        return footer
        
    }
}
//MARK: - layout size methods
extension HomeScreenMenuViewController: UICollectionViewDelegateFlowLayout {
    // size for header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize.zero
        }
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 10)
    }
    // size for footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize.zero
        }
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 40)
    }
    // size for each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 70)
    }
}
//MARK: - handle clicks

extension HomeScreenMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchCollectionView, !searchCompleterResults.isEmpty  {
            // todo
        }
    }
}

