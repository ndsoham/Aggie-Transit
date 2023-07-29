//
//  BusListScreenViewController+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

extension BusListScreenViewController {
    //MARK: - setup self
    func setupSelf() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.25)
    }
    //MARK: - setup collection view
    func setupCollectionView() {
        // init
        listCollectionView = UICollectionView(frame: CGRect(x: 0, y: Int(self.view.layoutMargins.top), width: Int(self.view.frame.width - (self.view.layoutMargins.left * 2)), height: Int(self.view.frame.height - (self.view.layoutMargins.top))), collectionViewLayout: singleColumnLayout)
        if let listCollectionView {
            // register cells and headers
            listCollectionView.register(BusListCollectionViewCell.self, forCellWithReuseIdentifier: BusListCollectionViewCell.id)
            listCollectionView.register(BusListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BusListHeaderView.id)
            // configure
            listCollectionView.backgroundColor = .clear
            listCollectionView.dataSource = self
            listCollectionView.delegate = self
            listCollectionView.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            self.view.addSubview(listCollectionView)
            // constrain
            NSLayoutConstraint.activate([
                listCollectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                listCollectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                listCollectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
                listCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
            ])
            
        }
    }
}
