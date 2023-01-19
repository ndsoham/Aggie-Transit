//
//  DirectionsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import UIKit

class DirectionsTableViewCell: UITableViewCell {
    private var horizontalStack: UIStackView = UIStackView()
    private var icon: UIImageView = UIImageView()
    var iconImage: UIImage?
    var iconTint: UIColor?
    private var directionsLabel: UILabel = UILabel()
    var directions: String?
    private var safeMargins: UILayoutGuide?
    private var leftPadding: Double?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImage = nil
        self.iconTint = nil
        self.directions = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        safeMargins = self.contentView.layoutMarginsGuide
        // configure the base view
        leftPadding = 5.0
        self.contentView.backgroundColor = UIColor(named: "menuColor")
        if let safeMargins = safeMargins, let leftPadding = leftPadding {
            
            // configure the icon and label
            if let iconImage, let directions = directions, let iconTint = iconTint {
                horizontalStack.translatesAutoresizingMaskIntoConstraints = false
                horizontalStack.axis = .horizontal
                horizontalStack.alignment = .leading
                horizontalStack.distribution = .fill
                horizontalStack.spacing = leftPadding
                // add to view hierarchy
                self.contentView.addSubview(horizontalStack)
                // add constraints
                horizontalStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: leftPadding).isActive = true
                horizontalStack.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant:  -leftPadding).isActive = true
                horizontalStack.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                // configure the other things
                icon.image = iconImage
                icon.tintColor = iconTint
                icon.translatesAutoresizingMaskIntoConstraints = false
                directionsLabel.text = directions
                directionsLabel.translatesAutoresizingMaskIntoConstraints = false
                directionsLabel.numberOfLines = 0
                directionsLabel.adjustsFontSizeToFitWidth = true
                // add to view hierarchy and constrain
                horizontalStack.addArrangedSubview(icon)
                horizontalStack.addArrangedSubview(directionsLabel)
                // constrain icon
                icon.widthAnchor.constraint(equalToConstant: 42).isActive = true
                icon.heightAnchor.constraint(equalToConstant: 42).isActive = true
                // constrain the label
                directionsLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
            }
            
        }
    }
}
