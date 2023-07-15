//
//  FavoritesTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit

class FavoritesTableViewCell: UITableViewCell {
    //MARK: - attributes
    let cellStack: UIStackView = UIStackView()
    let textStack: UIStackView = UIStackView()
    let iconImageView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    var name: String?
    var address: String?
    static let id: String = "FavoritesTableViewCell"
    //MARK: - inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
