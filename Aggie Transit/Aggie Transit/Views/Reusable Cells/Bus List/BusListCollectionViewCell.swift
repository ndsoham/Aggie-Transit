//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//

import UIKit

class BusListCollectionViewCell: UICollectionViewCell {
    //MARK: - attributes
    let textStack: UIStackView = UIStackView()
    let nameLabel: UILabel = UILabel()
    let stopsLabel: UILabel = UILabel()
    let numberLabel: UILabel = UILabel()
    var number: String?
    var name: String?
    var stops: String?
    static let id = "BusListCollectionViewCell"
    //MARK: - initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //MARK: - prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.number = nil
        self.name = nil
        self.stops = nil
    }
    //MARK: - layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setupNameAndStopsLabel()
        setupNumberLabel()
    }
}
