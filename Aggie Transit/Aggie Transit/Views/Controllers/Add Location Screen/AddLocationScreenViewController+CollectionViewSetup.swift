//
//  AddLocationScreenViewController+CollectionViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/30/23.
//

import Foundation
import UIKit

//MARK: - collection view data source/ delegate methods
extension AddLocationScreenViewController: UICollectionViewDataSource{
    // return number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchCollectionView {
            return searchCompleterResults.count
        }
        return 0
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
        }
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        return cell
    }
}
//MARK: - layout size methods
extension AddLocationScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 70)
    }
}
//MARK: - handle clicks

extension AddLocationScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchCollectionView, !searchCompleterResults.isEmpty  {
            // todo
        }
    }
}
