//
//  FavoritesTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    //MARK: - attributes
    let cellStack: UIStackView = UIStackView()
    let textStack: UIStackView = UIStackView()
    let iconImageView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    var name: String?
    var address: String?
    static let id: String = "FavoritesCollectionViewCell"
    //MARK: - inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //MARK: - life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name = nil
        self.address = nil
    }
    //MARK: - setup ui
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStacks()
        setupIcon()
        setupNameandAddress()
    }
    
    
}
