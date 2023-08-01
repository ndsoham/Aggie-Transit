//
//  SearchResultsViewController+CollectionViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/31/23.
//

import Foundation
import UIKit

//MARK: - collection view data source
extension SearchResultsViewController: UICollectionViewDataSource {
    // return number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    // return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenMenuCollectionViewCell.id, for: indexPath) as! HomeScreenMenuCollectionViewCell
        cell.address = "125 Spence St, College Station, TX, 77840"
        cell.name = "Zachry Engineering Education Complex"
        cell.iconTintColor = .red
        cell.icon = UIImage(systemName: "mappin.circle.fill")
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        return cell
    }
    
    
}
//MARK: - collection view delegate
extension SearchResultsViewController: UICollectionViewDelegate {
    
}

//MARK: - layout size methods
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 70)
    }
}
