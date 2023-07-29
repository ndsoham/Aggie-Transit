//
//  BusListScreenViewController+CollectionViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

//MARK: - data source/delegate methods
extension BusListScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let busRoutes {
            if filter == "On Campus" {
                filteredBusRoutes = busRoutes.filter{$0.campus == "On Campus"}
            } else if filter == "Off Campus" {
                filteredBusRoutes = busRoutes.filter{$0.campus == "Off Campus"}
            }
            self.activityIndicatorView.stopAnimating()
            return filteredBusRoutes.count
        }
        return 0
    }
    // return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusListCollectionViewCell.id, for: indexPath) as! BusListCollectionViewCell
        cell.stops = "Asbury Water Tower/ Becky Gates Center/ Asbury Water tower"
        cell.number = filteredBusRoutes[indexPath.row].number
        cell.name = filteredBusRoutes[indexPath.row].name
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = filteredBusRoutes[indexPath.row].color
        return cell
    }
    // return header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BusListHeaderView.id, for: indexPath) as! BusListHeaderView
        header.dismissalDelegate = self
        header.filterDelegate = self
        header.section = "On Campus"
        return header
    }
}

//MARK: - flow layout delegate methods

extension BusListScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 78)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - self.view.layoutMargins.right * 2, height: 30)
    }
}

//MARK: - header delegate methods

extension BusListScreenViewController: DismissalDelegate, FilterDelegate {
    func viewDismissed() {
        guard let presenter = self.presentingViewController as? HomeScreenViewController else {return}
            presenter.buttonStack.isHidden = false
        self.dismiss(animated: true) {
            presenter.presentMenu()
        }
    }
    
    func sectionChanged(newSection: String) {
        self.filter = newSection
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
            self.listCollectionView?.reloadData()
        }
    }
    
    
}

