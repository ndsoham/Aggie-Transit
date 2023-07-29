//
//  BusListScreenViewController+CollectionViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

//MARK: - sample bus struct

struct BusRouteSample {
    let name: String
    let stops: String
    let number: String
    let color: UIColor
}

//MARK: - sample data
let sampleRouteData: [BusRouteSample] = [
    BusRouteSample(name: "Bonfire", stops: "Commons/ Asbury / Reed Arena / MSC", number: "01", color: .purple),
    BusRouteSample(name: "Bonfire", stops: "Commons/ Asbury / Reed Arena / MSC", number: "01", color: .systemPink),
    BusRouteSample(name: "Bonfire", stops: "Commons/ Asbury / Reed Arena / MSC", number: "01", color: .black),
    BusRouteSample(name: "Bonfire", stops: "Commons/ Asbury / Reed Arena / MSC", number: "01", color: .red)
]
//MARK: - data source/delegate methods
extension BusListScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleRouteData.count
    }
    // return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusListCollectionViewCell.id, for: indexPath) as! BusListCollectionViewCell
        cell.stops = sampleRouteData[indexPath.row].stops
        cell.number = sampleRouteData[indexPath.row].number
        cell.name = sampleRouteData[indexPath.row].name
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.clipsToBounds = true
        cell.contentView.backgroundColor = sampleRouteData[indexPath.row].color
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
    
    func sectionChanged() {
        
    }
    
    
}

