//
//  SingleColumnLayout.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/15/23.
//

import Foundation
import UIKit

class SingleColumnLayout: UICollectionViewFlowLayout {
//MARK: - attributes
    private let cellHeight: CGFloat = 70.0
//MARK: - life cycle
    override func prepare() {
        super.prepare()
        guard let collectionView else {return}
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let cellWidth = availableWidth
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
//        sectionHeadersPinToVisibleBounds = true
    }
    
}
